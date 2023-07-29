# frozen_string_literal: true
# typed: true


module Prompts

  class Prompt
    class << self
      extend T::Sig

      def messages
        @messages ||= []
      end

      sig { params(message: String).void }
      def system(message)
        add_message(:system, message)
      end

      sig { params(role: Symbol, message: String).void }
      def add_message(role, message)
        case role
        when :user
          klass = Prompts::UserMessage
        when :system
          klass = Prompts::SystemMessage
        else
          raise StandardError, 'Invalid role'
        end
        messages.push klass.new(message)
      end

    end
  end
end
