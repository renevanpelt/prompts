# frozen_string_literal: true

# typed: true

module Prompts

  class Prompt

    attr_accessor :messages
    attr_accessor :parameters

    sig { params(prompt_builder: Prompts::PromptBuilder).void }
    def initialize(prompt_builder)
      raise MissingParameterValueError, "Missing parameters #{prompt_builder.missing_parameters.join(", ")}" unless prompt_builder.missing_parameters.empty?
    end

  end
end