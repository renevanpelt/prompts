require 'spec_helper'
require_relative '../lib/prompts'

describe Prompts::Message do
  it 'initializes with role and content' do

    msg = Prompts::Message.new('Hello, world!')

    expect(msg.role).to eq(:user)
    expect(msg.content).to eq('Hello, world!')
  end
end