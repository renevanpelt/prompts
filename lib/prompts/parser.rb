# frozen_string_literal: true

# typed = true

class Parser

  extend T::Sig

  sig { params(template: String).void }
  def initialize(template)
    @template = template
  end


  sig { returns(T::Array[Symbol]) }
  def parameter_names
    @template.scan(/\{\{(.*?)\}\}/).flatten.map(&:strip).map(&:to_sym)
  end

  sig { params(context: T::Hash[Symbol, T.untyped]).returns(String) }
  def parse(context)
    @template.gsub(/\{\{(.*?)\}\}/) { context[$1.strip.to_sym] || "{{#{$1}}}" }
  end
end