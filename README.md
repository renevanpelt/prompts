# prompts

This projects aims to provide a DLS for designing prompts. The goal is to enable developers to create complex prompts in a maintainable way.



Usage:

## Building a simple chat prompt

```ruby
require 'prompts'

# defining a prompt for translation

class TranslateToEnglish < Prompts::PromptBuilder

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

class TranslateTo < Prompts::PromptBuilder

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

You can also define one or more `parameter`s. We follow the structure of the OpenAI API, however, since they do not seem to make a semantic separation between receiving function call orders from the model and using the model as a function. We have added two more classes and some syntactic sugar to make this distinction. More about `DeterministicFunction` and `NonDeterministicFunction` later.

We start off with the Weather API example from the OpenAI API documentation.

```ruby

class GetCurrentWeather < Prompts::Function
  name :get_current_weather # optional, automatically generated based on class name
  description "Gets the current weather for a given location."

  parameter :location, required: true, type: :string, description: "A string containing a location, e.g. 'Amsterdam'"
  parameter :unit, required: true, type: :string,  enum: [:celsius, :fahrenheit], description: "The unit of temperature to return the weather in. Infer this from the users location"
  
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

@function_call_builder = FunctionCallForCurrentWeather.new
@function_call_builder.location = "Paris, France"

@prompt = @function_call_builder.to_prompt

# => Display the output 

@prompt.to_hash

# => Display the output

```

We use this prompt to in a call to the OpenAI API. In this example we use [ruby-openai by alexrudall](https://github.com/alexrudall/ruby-openai) to do so.

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

# => Display the output


```


We then use the response get information from our external API

```ruby

class ExternalWeatherMockAPI
  def self.response(location, unit)
    { temperature: Math.rand(0..30), rain_chance: "10%", unit: unit, location: location}
  end
end


response = response.dig(:choices, 1)
if response["finish_reason"] == "function_call" && GetCurrentWeather.validate(response["arguments"])
  api_response = ExternalWeatherMockAPI.response(response["arguments"]["location"], response["arguments"]["unit"])
else
  puts "We expected a function call here, but got something else."
end

```


Now we define a PropmtBuilder that uses the response from the API to build a response to the user.

```ruby

class CurrentWeather < Prompts::PromptBuilder
  
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
    functions: hash[:functions],
    temperature: 0.7,
  })

puts response


# => Display the output
```


### Making and using a Function class (The other way)



[//]: # ()
[//]: # (```ruby)

[//]: # (class NameParser < Prompts::Function)

[//]: # ()
[//]: # (  name :name_parser # optional: can be generated based on class name)

[//]: # (  description "Parses a full name into first name, last name and initials.")

[//]: # ()
[//]: # (  # Define a parameter on one line)

[//]: # (  parameter :full_name, required: true, type: :string, description: "A string containing a full name, e.g. 'John F. Doe'")

[//]: # ()
[//]: # (  returns :first_name, :last_name, :initials)

[//]: # (  # Or equivalently:)

[//]: # (  # parameter do)

[//]: # (  #   label: :full_name)

[//]: # (  #   required: true)

[//]: # (  #   type: :string)

[//]: # (  #   description: "A string containing a full name, e.g. 'John F. Doe'")

[//]: # (  #   # default: nil)

[//]: # (  # end)

[//]: # ()
[//]: # (end)

[//]: # ()
[//]: # (class ExtractNameFields < Prompts::PromptBuilder)

[//]: # ()
[//]: # (  function NameParser)

[//]: # ()
[//]: # (  system """)

[//]: # (        You are an agent that can )

[//]: # (        be interacted with though )

[//]: # (        natural language, but you )

[//]: # (        in the structure of the arguments )

[//]: # (        of the provided function)

[//]: # (        " "")

[//]: # ()
[//]: # (  user Function.invoke&#40;full_name: "John F. Doe"&#41;)

[//]: # ()
[//]: # (  system "{first_name: 'John', last_name: 'Doe', initials: 'JFD'}")

[//]: # ()
[//]: # (end)

[//]: # ()
[//]: # (prompt = ExtractNameFields.new)

[//]: # ()
[//]: # (prompt.invoke&#40;NameParser.new&#40;full_name: "John F. Doe"&#41;&#41;)

[//]: # ()
[//]: # (```)

[//]: # ()
[//]: # (Or, equivalently:)

[//]: # ()
[//]: # (```ruby)

[//]: # ()
[//]: # (class ExtractNameFields < Prompts::PromptBuilder)

[//]: # ()
[//]: # (  function NameParser)

[//]: # ()
[//]: # (  parameter :full_name, :string, "The full name that is to be parsed" # This is optional, but recommended.)

[//]: # ()
[//]: # (  system "" ")

[//]: # (        ...)

[//]: # (        " "")

[//]: # ()
[//]: # (  user NameParser.invoke&#40;full_name: "John F. Doe"&#41;)

[//]: # (  system "{first_name: 'John', last_name: 'Doe', initials: 'JFD'}")

[//]: # ()
[//]: # (  user NameParser.invoke&#40;full_name: full_name&#41;)

[//]: # ()
[//]: # (  # Or equivalently, to prevent name clashes)

[//]: # (  # user Function.invoke&#40;full_name: :full_name&#41;)

[//]: # ()
[//]: # (end)

[//]: # ()
[//]: # (prompt = ExtractNameFields.new)

[//]: # ()
[//]: # (prompt.full_name = "John F. Doe")

[//]: # ()
[//]: # (prompt.invoke)

[//]: # ()
[//]: # (```)

[//]: # ()
[//]: # (In the last example, we made the last user message dependent on the `full_name` parameter.)

## Tests

```$ rspec```

## Future development

- An `Agent` class to perform prompts based on user configuration
- Automatically generated web interface to interact with prompts and agents.
- Compatibility and recognition of ChatML https://github.com/openai/openai-python/blob/main/chatml.md
- Define a declarative language encompassing all functionality (proml)




