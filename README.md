# prompts

This is a gem for creating prompts for a conversational agent. It is a work in progress.

Usage:

## Simple chat prompt

```ruby
require 'prompts'


# defining a prompt for translation

class TranslateToEnglish < Prompts::Prompt
  
  system 'You are a helpful assistant that translates any text to English.'
  user 'Translate "hello" to Spanish.'
  agent 'This is not the kind of question I am expecting.'
  user 'Translate "Hola"'
  agent 'Hello'

end

# Create an instance
translate_prompt = TranslateToEnglish.new

# Invoke adds the string parameter as the latest (user) message and invokes the prompt.
translate_prompt.invoke('Mijn naam is Pieter')

# Invoke without a parameter
# => My name is Pieter

```

## Using parameters

The example above defines a prompt that specifically translate any language input to english. This is not very useful.
We can make it more useful by adding a parameter to the prompt.

```ruby

class TranslateTo < Prompts::Prompt
    
    system 'You are a helpful assistant that translates any text to {{target_language}}.'
    
    with_parameter :target_language, "Spanish" do |language|
        user 'Translate "hello"'
        agent 'Hello'
    end
    
    
    user 'Translate "Hola"'
    agent 'Hello'
    
    parameter :language, :string, "The language to translate to." # This is optional, but recommended.

end

# Create an instance

translate_to = TranslateTo.new

translate_to.invoke('Translate "Hello" to Spanish')

# => MissingParameterValueError

translate_to.parameters # => Returns an array of PromptParameter objects
translate_to.parameters[0].label # => "target_language"
translate_to.parameters[0].value # => nil

translate_to.missing_parameters == translate_to.parameters # => true

translate_to.target_language = 'Spanish'

translate_to.invoke('Translate "Hello"')

```

Note that we don't have to define the parameter in the user or agent messages. The parameter is automatically recognized
and replaced with the user input.

```ruby

## Tests

Run:
```$ rspec```


## Future development

- An `Agent` class to perform prompts based on user configuration
- Automatically generated web interface to interact with prompts and agents.
- Compatibility and recognition of ChatML https://github.com/openai/openai-python/blob/main/chatml.md
- Define a declarative language encompassing all functionality (proml)
