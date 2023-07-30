require 'spec_helper'

require_relative '../examples/functions/word_count'

require_relative '../examples/prompts/translate_to_english'
require_relative '../examples/prompts/translate_to'
require_relative '../examples/prompts/tell_me_the_opposite'
require_relative '../examples/prompts/simple_parameter_prompt'
require_relative '../examples/prompts/word_count_function_prompt'

require_relative './singleton_prompt_builder/invoke_spec'
require_relative './singleton_prompt_builder/to_hash_spec'

describe Prompts::SingletonPromptBuilder do
  let(:translate_to_english) { TranslateToEnglish.new }
  let(:translate_to) { TranslateTo.new }

  describe '.system' do
    it 'stores system prompt' do
      expect(translate_to_english.system_messages.count).to eq(1)
    end

    context 'when parameters are present' do
      it 'stores system prompt with parameters' do
        expect(translate_to.system_messages.count).to eq(1)
      end
    end
  end

  describe '.user' do
    it 'stores user prompts in order' do
      expect(translate_to_english.user_messages.count).to eq(2)

    end
  end

  describe '.assistant' do
    it 'stores agent prompts in order' do
      expect(translate_to_english.assistant_messages.count).to eq(2)
    end
  end


  describe '#to_prompt' do
    it 'returns a prompt object' do
      translate_to.target_language = 'Spanish'
      translate_to.foo = 'Bar'
      expect(translate_to.to_prompt).to be_a(Prompts::Prompt)
    end

    it 'raises error when missing parameters' do

      expect { translate_to.to_prompt }.to raise_error(Prompts::MissingParameterValueError)
    end

  end
end
