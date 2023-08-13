class WordCountFunctionPrompt < Prompts::SingletonPromptBuilder
  function WordCount
  system 'You help me count words'
  user 'How many words am I saying in this message?'
end