require 'spec_helper'

class TestFunctionWithName < Prompts::Function
  name :foo
end

class TestFunctionWithoutName < Prompts::Function; end

class TestFunction < Prompts::Function; end


describe Prompts::Function do
  describe '.name' do
    it 'sets the name of the function' do
      expect(TestFunctionWithName.internal_name).to eq :foo
    end

    it 'defaults to the class name if name is not explicitly set' do
      expect(TestFunction.internal_name).to eq :test_function
    end
  end

  describe '.name' do
    it 'raises error if two functions have the same name' do

      expect {

        class TestFunctionWithNameDup < Prompts::Function
          name :foo
        end

      }.to raise_error(Prompts::NameAlreadyTakenError)
    end
  end

  it 'sets the name of the function as a symbol' do
    expect(TestFunctionWithName.internal_name).to be_a(Symbol)
  end
  it 'raises error if function name is not in valid format' do

    expect {
      class TestFunctionWithInvalidName < Prompts::Function
        name "invalid-format"
      end

    }.to raise_error(Prompts::InvalidNameFormatError)
  end
end

describe '.new' do
  it 'creates an instance of the Function class' do
    instance = TestFunction.new
    expect(instance).to be_a(Prompts::Function)
  end
end
