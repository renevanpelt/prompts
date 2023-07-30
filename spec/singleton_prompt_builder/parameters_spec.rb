describe Prompts::SingletonPromptBuilder do
  let(:translate_to) { TranslateTo.new }

  describe 'parameter setters' do

    it('responds to target_language=') { expect(translate_to).to respond_to(:target_language=) }

    it 'allows setting the value of parameters' do
      translate_to.target_language = 'Spanish'
      expect(translate_to.target_language).to eq('Spanish')
    end
  end

  describe '.parameter' do
    it 'stores parameter information' do
      expect(translate_to.class.parameters).to include({ label: :foo, type: :string, description: "A description for foo." })
    end
  end

  describe '#missing_parameters' do
    it 'returns parameters with missing values' do
      expect(translate_to.missing_parameters).to eq(translate_to.class.parameters)
    end
  end

  describe '#missing_parameters' do
    it 'returns parameters with missing values' do
      expect(translate_to.missing_parameters).to eq(translate_to.class.parameters)
    end

    it 'returns empty array when all parameters are present' do
      translate_to.target_language = 'Spanish'
      expect(translate_to.missing_parameters).to eq([{ :label => :foo, :type => :string, :description => "A description for foo." }])

      translate_to.foo = 'Bar'
      expect(translate_to.missing_parameters).to eq([])
    end
  end

  describe '.[parameter_name]' do
    it 'returns parameter hash when the correct one is called' do
      expect(translate_to.class.foo).to eq({ label: :foo, type: :string, description: "A description for foo." })
    end

    it 'doesnt respond when method name is not a parameter label' do
      expect { translate_to.class.bar }.to raise_error(NoMethodError)
    end
  end

end