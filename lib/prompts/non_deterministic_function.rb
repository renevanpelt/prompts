

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
        return_fields << field
      end
    end

  end

end

