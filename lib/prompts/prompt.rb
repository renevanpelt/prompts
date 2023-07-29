# frozen_string_literal: true

# typed: true

module Prompts

  class Prompt

    extend T::Sig

    sig { params(prompt_builder: Prompts::PromptBuilder).void }
    def initialize(prompt_builder)
      raise MissingParameterValueError, "Missing parameters #{prompt_builder.missing_parameters.join(", ")}" unless prompt_builder.missing_parameters.empty?
      @messages = prompt_builder.parsed_messages
    end

    def to_hash
      {
        messages: @messages.map(&:to_hash)
      }
    end

  end
end