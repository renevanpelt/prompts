# typed: false
# frozen_string_literal: true

# typed = true

require 'sorbet-runtime'
require_relative 'prompts/prompt_builder'
require_relative 'prompts/message_builder'
require_relative 'prompts/function'
require_relative 'prompts/parser'
require_relative 'prompts/prompt'

module Prompts

  class NameAlreadyTakenError < StandardError; end

  class MissingParameterValueError < StandardError; end

  class SystemMessage < Prompts::MessageBuilder; end

  class UserMessage < Prompts::MessageBuilder; end

  class AgentMessage < Prompts::MessageBuilder; end

end




