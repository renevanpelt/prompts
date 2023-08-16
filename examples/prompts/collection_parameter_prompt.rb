class CollectionParameterPrompt < Prompts::SingletonPromptBuilder

  system 'You write a description of a topic following the same structure always.'

  every :example do
    user '{{example.topic}}'
    system '{{example.description}}'
  end

  user "{{topic}}"
end

