# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'
require_relative 'prompts/singleton_prompt_builder'
require_relative 'prompts/message_builder'
require_relative 'prompts/function'
require_relative 'prompts/parser'
require_relative 'prompts/prompt'
require_relative 'prompts/function_parameter'
require_relative 'prompts/function_return_value'
require_relative 'prompts/non_deterministic_function'
require_relative 'prompts/deterministic_function'

module Prompts

  class NameAlreadyTakenError < StandardError; end

  class MissingParameterValueError < StandardError; end

  class SystemMessage < Prompts::MessageBuilder
    def role
      :system
    end
  end

  class UserMessage < Prompts::MessageBuilder
    def role
      :user
    end
  end

  class UserFunctionMessage < Prompts::MessageBuilder
    attr_accessor :function
    def role
      :user_function
    end
  end

  class AssistantMessage < Prompts::MessageBuilder
    def role
      :assistant
    end
  end

end




