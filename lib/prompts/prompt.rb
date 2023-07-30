# frozen_string_literal: true
# typed: true

module Prompts

  class Prompt

    extend T::Sig

    sig { params(prompt_builder: Prompts::SingletonPromptBuilder).void }
    def initialize(prompt_builder)

      raise MissingParameterValueError, "Missing parameters #{prompt_builder.missing_parameters.join(", ")}" unless prompt_builder.missing_parameters.empty?

      @messages = T.let(prompt_builder.parsed_messages, T::Array[Prompts::Message])
      @functions = T.let(prompt_builder.class.functions, T::Array[T::Class[Prompts::Function]])
    end

    sig { returns(T::Hash[Symbol, T::Array[T.untyped]]) }
    def to_hash
      {
        messages: @messages.map(&:to_hash),
        functions: @functions.map { |f| f.new.to_hash }
      }
    end

  end
end
