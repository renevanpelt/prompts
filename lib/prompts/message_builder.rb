# frozen_string_literal: true
# typed: true

module Prompts

  class Message < T::Struct
    prop :role, T.anything
    prop :content, T.anything
    def to_hash
      {
        role: role,
        content: content
      }
    end
  end

  class MessageBuilder
    extend T::Sig

    attr_accessor :content, :parameter_requirements

    def initialize(content, kwargs = {})
      raise StandardError, 'Only child classes can be initialized' if self.instance_of?(Prompts::MessageBuilder)
      this.function = kwargs[:function] if role == :user_function
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
