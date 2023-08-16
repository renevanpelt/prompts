require 'spec_helper'
require_relative '../../examples/prompts/collection_parameter_prompt'

describe Prompts::SingletonPromptBuilder do
  let(:collection_prompt) { CollectionParameterPrompt.new }

  describe '#every' do
    it 'finds a collection parameter' do
      expect( collection_prompt.user_messages.count).to be(1)
    end

    it 'finds a regular parameter' do
    end
  end

end
