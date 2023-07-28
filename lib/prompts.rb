# typed: false
# frozen_string_literal: true

# typed = true


require 'sorbet-runtime'
require_relative 'prompts/prompt'
require_relative 'prompts/message'

module Prompts

  class SystemMessage < Prompts::Message
  end

  class UserMessage < Prompts::Message
  end

end




