# frozen_string_literal: true

# typed: true

module Prompts
  class Message
    extend T::Sig

    attr_accessor :message

    sig { params(message: String).void }
    def initialize(message)
      raise StandardError, 'Only child classes can be initialized' if self.class == (Prompts::Message)

      self.message = message
      # validate!
    end
  end
end
