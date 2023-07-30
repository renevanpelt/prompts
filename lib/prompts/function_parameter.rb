
class FunctionParameter < T::Struct
  prop :name, Symbol
  prop :required, T::Boolean
  prop :enum, T.nilable(T::Array[Symbol])
  prop :type, Symbol
  prop :description, String

  def to_hash
    h = {
      name: name,
      required: required,
      type: type,
      description: description
    }
    h[:enum] = enum unless enum.nil?
    h
  end
end