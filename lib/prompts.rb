# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'
require_relative 'prompts/prompt_builder'
require_relative 'prompts/message_builder'
require_relative 'prompts/function'
require_relative 'prompts/parser'
require_relative 'prompts/prompt'

module Prompts

  class NameAlreadyTakenError < StandardError; end

  class MissingParameterValueError < StandardError; end

  class SystemMessage < Prompts::MessageBuilder;
    def role
      :system
    end
  end

  class UserMessage < Prompts::MessageBuilder
    def role
      :user
    end
  end

  class AgentMessage < Prompts::MessageBuilder
    def role
      :agent
    end
  end

end




