# frozen_string_literal: true
# typed: true


class Prompt
  extend T::Sig
  class <<


    def messages
      @messages = []
    end

    sig { params(message: String).void }
    def system(message)
      add_message(SystemMessage, message)
    end


    sig { params(role: Symbol, message: String).void }
    def add_message(klass, message)
      case role
      when :user
        klass = UserMessage
      when :system
        klass = SystemMessage
      else
        raise StandardError, 'Invalid role'
      end
      klass.new(message)
    end

  end
end