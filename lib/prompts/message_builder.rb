# frozen_string_literal: true

# typed: true

module Prompts



  class MessageBuilder
    extend T::Sig

    attr_accessor :content, :parameter_requirements

    sig { params(content: String).void }
    def initialize(content)
      raise StandardError, 'Only child classes can be initialized' if self.instance_of?(Prompts::MessageBuilder)

      self.content = content
      self.parameter_requirements = []
    end


    sig { params(parameters: T::Hash[Symbol, String]).returns(String) }
    def parse(parameters)
      parser = Parser.new(content)
      parser.parse(parameters)
    end

  end
end
