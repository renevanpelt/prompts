class SimpleParameterPrompt < Prompts::SingletonPromptBuilder

  system 'You respond in dutch, whatever language the user speaks in'
  user 'Tell me something about {{topic}}'

end

