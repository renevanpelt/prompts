

class Prompts::NonDeterministicFunction < Prompts::Function

  def type
    :non_deterministic
  end

  def initialize(arguments)
    @arguments = arguments
  end

  def invoke
    self
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
      new(kwargs).invoke
    end

  end

end

