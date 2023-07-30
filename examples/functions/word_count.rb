class WordCount < Prompts::Function
  name "word_count"
  description "Counts the number of words in a string"
  parameter :string,
            required: true,
            type: :string,
            description: "A string of which the words are to be counted"
end
