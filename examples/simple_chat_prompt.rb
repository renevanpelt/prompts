require 'example_helper'

class TranslateToEnglish < Prompts::SingletonPromptBuilder

  system 'You are a helpful assistant that translates any text to English.'
  user 'Translate "hello" to Spanish.'
  assistant 'This is not the kind of question I am expecting.'
  user 'Translate "Hola"'
  assistant 'Hello'

end

translate_prompt = TranslateToEnglish.new
puts translate_prompt.invoke('Mijn naam is Pieter')
