# prompts

This projects aims to provide a DLS for designing prompts. The goal is to enable developers to create complex prompts in
a maintainable way.

## Building a simple chat prompt

```ruby
require 'prompts'

# defining a prompt for translation

class TranslateToEnglish < Prompts::SingletonPromptBuilder

  system 'You are a helpful assistant that translates any text to English.'
  user 'Translate "hello" to Spanish.'
  assistant 'This is not the kind of question I am expecting.'
  user 'Translate "Hola"'
  assistant 'Hello'

end

# Create an instance
translate_prompt = TranslateToEnglish.new

# Invoke adds the string parameter as the latest (user) message and invokes the prompt.
translate_prompt.invoke('Mijn naam is Pieter')

# Invoke without a parameter
# => My name is Pieter

```

## Using parameters in your prompts

The example above defines a prompt that specifically translate any language input to english. This is not very useful.
We can make it more useful by adding a parameter to the prompt.

```ruby

class TranslateTo < Prompts::SingletonPromptBuilder

  system 'You are a helpful assistant that translates any text to {{target_language}}.'

  with_parameter :target_language, "Spanish" do |language|
    user 'Translate "hello"'
    assistant 'Hello'
  end

  user 'Translate "Hola"'
  assistant 'Hello'

  parameter :language, :string, "The language to translate to." # This is optional, but recommended.

end

# Create an instance

translate_to = TranslateTo.new

translate_to.invoke('Translate "Hello" to Spanish')

# => MissingParameterValueError

translate_to.class.parameters # => Returns an array of PromptParameter objects
translate_to.class.parameters[0].label # => "target_language"
translate_to.parameters[0].value # => nil

translate_to.missing_parameters == translate_to.class.parameters # => true

translate_to.target_language = 'Spanish'

translate_to.invoke('Translate "Hello"')
```

Note that we don't have to define the parameter in the user or agent messages. The parameter is automatically recognized
and replaced with the user input.

## Using functions

Functions in the OpenAI API can be used in several ways:

- Extracting structured data from unstructured text
- Getting structured answers to human language queries
- Giving the agent access to logic in the outside world

### Making and using a Function class (The OpenAI API way)

Defining function classes requires at least a `name` and a `description`.

You can also define one or more `parameter`s. We follow the structure of the OpenAI API, however, since they do not seem
to make a semantic separation between receiving function call orders from the model and using the model as a function.
We have added two more classes and some syntactic sugar to make this distinction. More about `DeterministicFunction`
and `NonDeterministicFunction` later.

We start off with the Weather API example from the OpenAI API documentation.

```ruby
class GetCurrentWeather < Prompts::Function
  name :get_current_weather # optional, automatically generated based on class name
  description "Gets the current weather for a given location."

  parameter :location, required: true, type: :string, description: "A string containing a location, e.g. 'Amsterdam'"
  parameter :unit, required: true, type: :string, enum: [:celsius, :fahrenheit], description: "The unit of temperature to return the weather in. Infer this from the users location"

end

class FunctionCallForWeather < Prompts::PromoptBuilder
  function GetCurrentWeather
  parameter :location, :string, "The location to get the weather for"

  system "Tell me what the current weather is in {{location}}"
end
```

We created the function and provided it to our beautifully named `FunctionCallForWeather` prompt builder.

We will now build the prompt, by providing a location through the dynamic `location` setter.

```ruby

@function_call_builder = FunctionCallForWeather.new
@function_call_builder.location = "Paris, France"

@prompt = @function_call_builder.to_prompt

# => #<Prompts::Prompt:0x0000000104508020>

@prompt.to_hash

# => {:messages=>[{:role=>:system, :content=>"Tell me what the current weather is in Paris, France"}], :functions=>[{:name=>:get_current_weather, :description=>"Gets the current weather for a given location.", :parameters=>{:type=>:object, :properties=>{:location=>{:type=>:string, :description=>"A string containing a location, e.g. 'Amsterdam'"}, :unit=>{:type=>:string, :description=>"The unit of temperature to return the weather in. Infer this from the users location"}}}}]}


```

We use this prompt to in a call to the OpenAI API. In this example we
use [ruby-openai by alexrudall](https://github.com/alexrudall/ruby-openai) to do so.

In future implementations, doing API calls to several providers should probably be within the scope of this project.

```ruby

client = OpenAI::Client.new

hash = @prompt.to_hash

response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: hash[:messages],
    functions: hash[:functions],
    temperature: 0.7,
  })

puts response
```

Which renders the following response

```json
{
  "id": "chatcmpl-7hnJW7JgsnAoEiTg1AXi7YEqKdWQf",
  "object": "chat.completion",
  "created": 1690672022,
  "model": "gpt-3.5-turbo-0613",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "function_call": {
          "name": "get_current_weather",
          "arguments": "{\n  \"location\": \"Paris, France\"\n}"
        }
      },
      "finish_reason": "function_call"
    }
  ],
  "usage": {
    "prompt_tokens": 93,
    "completion_tokens": 18,
    "total_tokens": 111
  }
}
```

We then use the response get information from our external API

```ruby


class ExternalWeatherMockAPI
  def self.response(location, unit)
    { temperature: rand(0..30), rain_chance: "10%", unit: unit, location: location }
  end
end

response = JSON.parse(response.to_s)
response = response.dig("choices", 0)
if response["finish_reason"] == "function_call"
  arguments = JSON.parse response["message"]["function_call"]["arguments"]
else
  puts "We expected a function call here, but got something else."
end

if GetCurrentWeather.validate(arguments)
  api_response = ExternalWeatherMockAPI.response(arguments["location"], arguments["unit"])
else
  puts "The arguments were not valid"
end



```

Now we define a PropmtBuilder that uses the response from the API to build a response to the user.

```ruby


class CurrentWeather < Prompts::SingletonPromptBuilder

  parameter :api_response, :hash, "The response from the external API"

  system "You give the user the current weather given a raw response from an external API."
  system "API Response: {{api_response}}"

end

current_weather_builder = CurrentWeather.new
current_weather_builder.api_response = api_response

hash = current_weather_builder.to_prompt.to_hash


```

Again, we do an API call

```ruby
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: hash[:messages],
    temperature: 0.7,
  })

response = JSON.parse(response.to_s)
puts response = response.dig("choices", 0, "message", "content")

# => The current weather in Paris, France is 7 degrees Celsius with a 10% chance of rain.

```

### Making and using a Function class (The other way)


### Using the models as non-deterministic functions











## Tests

```$ rspec```

## Future development

- An `Agent` class to perform prompts based on user configuration
- Automatically generated web interface to interact with prompts and agents.
- Compatibility and recognition of ChatML https://github.com/openai/openai-python/blob/main/chatml.md
- Define a declarative language encompassing all functionality (proml)




