class TranslateTo < Prompts::SingletonPromptBuilder
  system 'You are a helpful assistant that translates any text to {{target_language}}.'
  with_parameter :target_language, "Spanish" do |language|
    user 'Translate "hello"'
    assistant 'Hello'
  end

  user 'Translate "Hola"'
  assistant 'Hello'
  parameter :foo, :string, "A description for foo."
end