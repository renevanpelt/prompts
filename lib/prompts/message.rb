# frozen_string_literal: true

# typed: true

module Prompts
  class Message
    extend T::Sig

    attr_accessor :message
    attr_accessor :parameter_requirements

    sig { params(message: String).void }
    def initialize(message)
      raise StandardError, 'Only child classes can be initialized' if self.instance_of?(Prompts::Message)

      self.message = message
      self.parameter_requirements = []
    end
  end
end
