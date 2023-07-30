describe Prompts::SingletonPromptBuilder do

  describe '#to_hash' do
    it 'should give a correct hash in a simple case' do

      p = TellMeTheOpposite.new

      expected_hash = {
        functions: [],
        messages: [
          {
            role: :system,
            content: 'You tell the opposite of what people are saying.'
          },
          {
            role: :user,
            content: 'The sun is round'
          },
          {
            role: :system,
            content: 'the sun is a square'
          }

        ]
      }
      expect(p.to_prompt.to_hash).to eq(expected_hash)

    end

    it 'should give a correct hash in a simple case with parameters' do

      p = SimpleParameterPrompt.new
      p.topic = 'the weather'
      expected_hash = { :messages => [{ :role => :system, :content => "You respond in dutch, whatever language the user speaks in" }, { :role => :user, :content => "Tell me something about the weather" }], :functions => [] }

      expect(p.to_prompt.to_hash).to eq(expected_hash)

    end

    it 'should give a correct hash in a simple case with a function' do

      p = WordCountFunctionPrompt.new
      expected_hash = { :messages => [{ :role => :system, :content => "You help me count words" }, { :role => :user, :content => "How many words am I saying in this message?" }], :functions => [{ :description => "Counts the number of words in a string", :name => :word_count, :parameters => { :properties => { :string => { :description => "A string of which the words are to be counted", :type => :string } }, :type => :object } }] }

      expect(p.to_prompt.to_hash).to eq(expected_hash)

    end

  end
end
