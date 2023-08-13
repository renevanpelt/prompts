

class Prompts::NonDeterministicFunction < Prompts::Function

  def type
    :non_deterministic
  end

  def self.new_with_arguments(arguments)
    object = new
    object.arguments = arguments
    object
  end

  attr_writer :arguments

  def invoke
    puts "boo"
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
      puts "we get here"
      new_with_arguments(kwargs).invoke
    end

  end

end

