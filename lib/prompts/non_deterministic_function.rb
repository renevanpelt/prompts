

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


    # Takes keyword arguments
    def invoke(**kwargs)
      builder_klass = Promp
      new(**kwargs).invoke
    end

  end

end

