require 'spec_helper'

class FooBarFunction < Prompts::NonDeterministicFunction
  returns :bar, :baz
end

RSpec.describe Prompts::NonDeterministicFunction do


  describe '#type' do
    it 'returns :non_deterministic' do
      non_deterministic_function = Prompts::NonDeterministicFunction.new
      expect(non_deterministic_function.type).to eq(:non_deterministic)
    end
  end

  describe '.returns' do
    it 'adds the given fields to return_fields' do
      Prompts::NonDeterministicFunction.returns :foo, :bar
      return_fields = Prompts::NonDeterministicFunction.return_fields

      expect(return_fields.map(&:name)).to contain_exactly(:foo, :bar)
      expect(return_fields).to all( be_a(Prompts::FunctionReturnValue) )
    end
  end

  describe '#return_fields' do
    it 'returns the return fields' do
      expect(FooBarFunction.return_fields.map(&:name)).to contain_exactly(:bar, :baz)
    end
  end

end