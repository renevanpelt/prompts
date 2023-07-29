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

      sig { params(message: String).void }
      def user(message)
        add_message(:user, message)
      end

      sig { params(message: String).void }
      def agent(message)
        add_message(:agent, message)
      end

      sig { params(role: Symbol, message: String).void }
      def add_message(role, message)
        case role
        when :user
          klass = Prompts::UserMessage
        when :system
          klass = Prompts::SystemMessage
        when :agent
          klass = Prompts::AgentMessage
        else
          raise StandardError, 'Invalid role'
        end
        messages.push klass.new(message)
      end

      sig { params(name: Symbol, default: T.untyped, block: T.proc.void).void }
      def with_parameter(name, default = nil, &block)
        parameters << {name: name, default: default}
        self.instance_eval(&block)
      end

      sig { params(name: Symbol, type: T.untyped, description: String).void }
      def parameter(name, type, description)
        @parameters << {name: name, type: type, description: description}
      end

      def parameters
        @parameters ||= []
      end

      sig { params(value: T.untyped).returns(Symbol) }
      def parse_parameter_value(value)

      end

      sig { returns(T::Array[Hash]) }
      def missing_parameters
        parameters.select { |p| p[:value].nil? }
      end

      end

    # define setters for parameters
    parameters.each do |param|
      define_method("#{param[:name]}=") do |value|
        param[:value] = parse_parameter_value(value)
      end
    end
  end
end
