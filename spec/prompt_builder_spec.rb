require 'spec_helper'

class TranslateToEnglish < Prompts::PromptBuilder
  system 'You are a helpful assistant that translates any text to English.'
  user 'Translate "hello" to Spanish.'
  agent 'This is not the kind of question I am expecting.'
  user 'Translate "Hola"'
  agent 'Hello'
end

class TranslateTo < Prompts::PromptBuilder
  system 'You are a helpful assistant that translates any text to {{target_language}}.'
  with_parameter :target_language, "Spanish" do |language|
    user 'Translate "hello"'
    agent 'Hello'
  end
  user 'Translate "Hola"'
  agent 'Hello'
  parameter :foo, :string, "A description for foo."
end

class Translate < Prompts::PromptBuilder

end

describe Prompts::PromptBuilder do
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

  describe '.agent' do
    it 'stores agent prompts in order' do
      expect(translate_to_english.agent_messages.count).to eq(2)
    end
  end

  describe '#invoke' do
    it 'responds to invoke method' do
      expect(translate_to_english).to respond_to(:invoke)
    end

    context 'when parameters are required' do
      it 'throws error when missing required parameters' do
        expect { translate_to.invoke('Translate "Hello"') }.to raise_error(Prompts::MissingParameterValueError)
      end
    end

  end

  describe 'parameter setters' do

    it('responds to target_language=') { expect(translate_to).to respond_to(:target_language=) }

    it 'allows setting the value of parameters' do
      translate_to.target_language = 'Spanish'
      expect(translate_to.target_language).to eq('Spanish')
    end
  end

  describe '.parameter' do
    it 'stores parameter information' do
      expect(translate_to.class.parameters).to include({ label: :foo, type: :string, description: "A description for foo." })
    end
  end

  describe '#missing_parameters' do
    it 'returns parameters with missing values' do
      expect(translate_to.missing_parameters).to eq(translate_to.class.parameters)
    end
  end

  describe '#missing_parameters' do
    it 'returns parameters with missing values' do
      expect(translate_to.missing_parameters).to eq(translate_to.class.parameters)
    end

    it 'returns empty array when all parameters are present' do
      translate_to.target_language = 'Spanish'
      expect(translate_to.missing_parameters).to eq([{ :label => :foo, :type => :string, :description => "A description for foo." }])

      translate_to.foo = 'Bar'
      expect(translate_to.missing_parameters).to eq([])
    end
  end

  describe '.[parameter_name]' do
    it 'returns parameter hash when the correct one is called' do
      expect(translate_to.class.foo).to eq({ label: :foo, type: :string, description: "A description for foo." })
    end

    it 'doesnt respond when method name is not a parameter label' do
      expect { translate_to.class.bar }.to raise_error(NoMethodError)
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

class SimpleOppositePrompt < Prompts::PromptBuilder

  system 'You tell the opposite of what people are saying.'
  user 'The sun is round'
  system 'the sun is a square'

end

describe Prompts::PromptBuilder do

  describe '#to_hash' do
    it 'should give a correct hash in a simple case' do

      p = SimpleOppositePrompt.new

      expected_hash = {
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

  end
end


class SimpleParameterPrompt < Prompts::PromptBuilder

  system 'You respond in dutch, whatever language the user speaks in'
  user 'Tell me something about {{topic}}'

end

describe Prompts::PromptBuilder do

  describe '#to_hash' do
    it 'should give a correct hash in a simple case with parameters' do

      p = SimpleParameterPrompt.new
      p.topic = 'the weather'
      expected_hash = {:messages=>[{:role=>:system, :content=>"You respond in dutch, whatever language the user speaks in"}, {:role=>:user, :content=>"Tell me something about the weather"}]}

      expect(p.to_prompt.to_hash).to eq(expected_hash)

    end

  end
end


