
class TellMeTheOpposite < Prompts::SingletonPromptBuilder

  system 'You tell the opposite of what people are saying.'
  user 'The sun is round'
  system 'the sun is a square'

end
