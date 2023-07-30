

class Prompts::NonDeterministicFunction < Prompts::Function

  def type
    :non_deterministic
  end

  class << self


    def return_fields
      @return_fields ||= []
    end

    def returns *fields
      fields.each do |field|
        return_fields << Prompts::FunctionReturnValue.new(field)
      end
    end

    def invoke(**kwargs)

    end

  end

end

