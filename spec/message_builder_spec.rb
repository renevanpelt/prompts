require 'spec_helper'
require_relative '../lib/prompts'

describe Prompts::MessageBuilder do
  it 'should raise error when initialized directly' do
    expect { Prompts::MessageBuilder.new('Hello, world!') }.to raise_error(StandardError, 'Only child classes can be initialized')
  end
end

class MyPrompt < Prompts::SingletonPromptBuilder
  system 'Hello, world!'
end

describe Prompts::SystemMessage do

  it 'should be initialized with a message' do
    expect(MyPrompt.message_builders.first).to be_a(Prompts::SystemMessage)
    expect(MyPrompt.message_builders.first&.content).to eq('Hello, world!')

  end

end