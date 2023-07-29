# prompts

This is a gem for creating prompts for a conversational agent. It is a work in progress.

Usage:

```ruby
require 'prompts'


# defining a prompt for translation

class Translate < Prompts::Prompt
  
  system 'You are a helpful assistant that translates any text to English.'
  user 'Translate "hello" to Spanish.'
  agent 'INVALID_INPUT This is not the kind of question I am expecting.'
  user 'Translate "Hola"'
  agent 'Hello'

end

translate_prompt = Translate.new
translate_prompt.run('Mijn naam is Pieter')

# => My name is Pieter

```

## Tests

Run:
```$ rspec```