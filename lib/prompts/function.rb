# frozen_string_literal: true

# typed: true

module Prompts

  class Function
    @@names = [] # class variable to store names

    def to_hash
      {
        name: self.class.internal_name,
        description: self.class.description,
        parameters: {
          type: :object,
          properties: self.class.parameters.map { |a| [a.name, { :type => a.type, :description => a.description }] }.to_h,
        }
      }
    end

    class << self
      extend T::Sig

      sig { params(name: T.any(String, Symbol)).void }
      def name(name)
        sym_name = name.to_sym
        validate_name(sym_name)
        raise NameAlreadyTakenError, "Name already taken" if @@names.include?(sym_name)

        @@names << sym_name
        @internal_name = sym_name
      end

      sig { returns(Symbol) }
      def internal_name
        constant_name = T.let(to_s, String)
        parts = T.let(constant_name.split('::'), T::Array[String])
        raise StandardError, 'Invalid class name' if parts.empty?

        class_name = parts.last


        @internal_name ||= snake_case(class_name).to_sym
      end

      sig { params(description: T.nilable(String)).returns(String) }
      def description(description = nil)
        @description = description if description
        return @description
      end

      sig { returns(T::Array[FunctionParameter]) }
      def parameters
        @parameters ||= []
      end

      # sig { params(name_or_object: T.any(Symbol, FunctionParameter), kwargs: T::Hash[Symbol, T.untyped]).void }
      def parameter(name_or_object, **kwargs)
        case name_or_object
        when Symbol
          obj = FunctionParameter.new(name: name_or_object, enum: kwargs[:enum], required: kwargs[:required], type: kwargs[:type], description: kwargs[:description])

        when FunctionParameter
          obj = name_or_object
        else
          raise InvalidParameterError, "Invalid parameter, must be a hash or a FunctionParameter object, got #{name_or_object.class}"
        end
        parameters << obj
      end

      sig { params(arguments: T::Hash[Symbol, T.untyped]).returns(T::Boolean) }
      def validate(arguments)
        parameters.select { |a| a.required }.select { |a| arguments.has_key?(a.name) }.none?
      end

      private

      sig { params(str: T.nilable(String)).returns(String) }
      def snake_case(str)
        return nil unless str

        str.gsub(/::/, '/')
           .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2')
           .tr("-", "_")
           .downcase
      end

      sig { params(name: Symbol).void }
      def validate_name(name)
        valid = /\A[a-zA-Z_][a-zA-Z0-9_]*\z/ =~ name.to_s
        raise InvalidNameFormatError, "Invalid name format" unless valid
      end
    end
  end

  class NameAlreadyTakenError < StandardError; end

  class InvalidNameFormatError < StandardError; end

  class InvalidParameterError < StandardError; end
end
