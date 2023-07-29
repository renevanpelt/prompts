# frozen_string_literal: true

# typed: true

module Prompts
  class Message
    extend T::Sig

    attr_accessor :content
    attr_accessor :parameter_requirements

    sig { params(content: String).void }
    def initialize(content)
      raise StandardError, 'Only child classes can be initialized' if self.instance_of?(Prompts::Message)

      self.content = content
      self.parameter_requirements = []
    end
  end
end
