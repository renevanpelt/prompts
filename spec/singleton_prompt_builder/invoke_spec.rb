describe Prompts::SingletonPromptBuilder do
  let(:translate_to) { TranslateTo.new }
  let(:translate_to_english) { TranslateToEnglish.new }

  describe '#invoke' do
    it 'responds to invoke method' do
      expect(translate_to_english).to respond_to(:invoke)
    end

    context 'when parameters are required' do
      it 'throws error when missing required parameters' do
        expect { translate_to.invoke('Translate "Hello"') }.to raise_error(Prompts::MissingParameterValueError)
      end
    end

  end
end