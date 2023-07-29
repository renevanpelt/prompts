require 'rspec'
require 'spec_helper'

RSpec.describe Parser do
  it 'replaces a template variable' do
    template = Parser.new("Hello, {{name}}")
    expect(template.parse({ name: "world" })).to eq("Hello, world")
  end

  it 'replaces multiple template variables' do
    template = Parser.new("Hello, {{name}}, you are {{age}} years old")
    expect(template.parse({ name: "world", age: "22" })).to eq("Hello, world, you are 22 years old")
  end

  it 'ignores spaces around variable names' do
    template = Parser.new("Hello, {{ name }}")
    expect(template.parse({ name: "world" })).to eq("Hello, world")
  end

  it 'leaves unmatched variables in place' do
    template = Parser.new("Hello, {{name}}, you are from {{city}}")
    expect(template.parse({ name: "world" })).to eq("Hello, world, you are from {{city}}")
  end

  describe "#parameter_names" do
    it 'returns an empty array when there are no parameters' do
      template = Parser.new("Hello, world")
      expect(template.parameter_names).to eq([])
    end

    it 'returns an array of parameter names' do
      template = Parser.new("Hello, {{name}}, you are from {{city}}")
      expect(template.parameter_names).to eq([:name, :city])
    end
  end

end
