require 'spec_helper'

RSpec.describe Prompts::NonDeterministicFunction do

  describe '#type' do
    it 'returns :non_deterministic' do
      non_deterministic_function = Prompts::DeterministicFunction.new
      expect(non_deterministic_function.type).to eq(:deterministic)
    end
  end

  describe '.return_fields' do

  end

end