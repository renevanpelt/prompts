# prompts

This is a gem for creating prompts for a conversational agent. It is a work in progress.

Usage:

## Simple chat prompt

```ruby
require 'prompts'

# defining a prompt for translation

class TranslateToEnglish < Prompts::PromptBuilder

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

class TranslateTo < Prompts::PromptBuilder

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

# Using the model as a function

```ruby

class NameParser < Prompts::Function

  name :name_parser # optional: can be generated based on class name
  description "Parses a full name into first name, last name and initials."

  # Define a parameter on one line
  parameter :full_name, required: true, type: :string, description: "A string containing a full name, e.g. 'John F. Doe'"

  returns :first_name, :last_name, :initials
  # Or equivalently:
  # parameter do
  #   label: :full_name
  #   required: true
  #   type: :string
  #   description: "A string containing a full name, e.g. 'John F. Doe'"
  #   # default: nil
  # end

end

class ExtractNameFields < Prompts::PromptBuilder

  function NameParser

  system "" "
        You are an agent that can 
        be interacted with though 
        natural language, but you 
        in the structure of the arguments 
        of the provided function
        " ""

  user Function.invoke(full_name: "John F. Doe")

  system "{first_name: 'John', last_name: 'Doe', initials: 'JFD'}"

end

prompt = ExtractNameFields.new

prompt.invoke(NameParser.new(full_name: "John F. Doe"))

```

Or, equivalently:

```ruby

class ExtractNameFields < Prompts::PromptBuilder

  function NameParser

  parameter :full_name, :string, "The full name that is to be parsed" # This is optional, but recommended.

  system "" "
        ...
        " ""

  user NameParser.invoke(full_name: "John F. Doe")
  system "{first_name: 'John', last_name: 'Doe', initials: 'JFD'}"

  user NameParser.invoke(full_name: full_name)

  # Or equivalently, to prevent name clashes
  # user Function.invoke(full_name: :full_name)

end

prompt = ExtractNameFields.new

prompt.full_name = "John F. Doe"

prompt.invoke

```

In the last example, we made the last user message dependent on the `full_name` parameter.

## Tests

```$ rspec```

## Future development

- An `Agent` class to perform prompts based on user configuration
- Automatically generated web interface to interact with prompts and agents.
- Compatibility and recognition of ChatML https://github.com/openai/openai-python/blob/main/chatml.md
- Define a declarative language encompassing all functionality (proml)
