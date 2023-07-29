# typed: false
# frozen_string_literal: true

# typed = true


require 'sorbet-runtime'
require_relative 'prompts/prompt'
require_relative 'prompts/message'
require_relative 'prompts/function'


module Prompts
  class NameAlreadyTakenError < StandardError; end

  class SystemMessage < Prompts::Message
  end

  class UserMessage < Prompts::Message
  end

end




