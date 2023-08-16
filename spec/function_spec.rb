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


class NameParser < Prompts::Function
  name :name_parser
  description "Parses a full name into first name, last name and initials."
  parameter :full_name, required: true, type: :string, description: "A string containing a full name, e.g. 'John F. Doe'"
  # returns :first_name, :last_name, :initials
end

class ExtractNameFields < Prompts::SingletonPromptBuilder
  function NameParser
  parameter :full_name, :string, "The full name that is to be parsed"
end





describe NameParser do

  it 'should have a description' do
    expect(NameParser.description).to eq("Parses a full name into first name, last name and initials.")
  end

  it 'should have a parameter :full_name' do
    expect(NameParser.parameters.map{|a| a.to_hash}).to include({name: :full_name, required: true, type: :string, description: "A string containing a full name, e.g. 'John F. Doe'"})
  end

end

describe ExtractNameFields do
  it 'should have a function' do
    expect(ExtractNameFields.functions.first).to eq(NameParser)
    expect(ExtractNameFields.functions.count).to eq(1)
  end

  it 'should have a parameter :full_name' do

    expect(ExtractNameFields.parameters).to include({label: :full_name,:message_builders=>[], type: :string, description: "The full name that is to be parsed"})
  end
end

describe 'invoke function' do
  # it 'should return a result when invoked' do
  #   prompt = ExtractNameFields.new
  #   prompt.full_name = "John F. Doe"
  #   result = prompt.invoke
  #   expect(result).to eq({first_name: 'John', last_name: 'Doe', initials: 'JFD'})
  # end
end
