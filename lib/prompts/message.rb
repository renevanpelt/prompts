# frozen_string_literal: true
# typed: true


module Prompts

  class Message
    extend T::Sig

    attr_acessor :message

    sig { params(message: String).void }
    def initialize(message)
      raise StandardError, 'Only child classes can be initialized' if is_a?(Prompts::Message)

      this.message = message
      validate!
    end
  end
end
