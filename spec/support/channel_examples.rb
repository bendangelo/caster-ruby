module Caster
  RSpec.shared_examples 'channel' do
    include_context 'client'

    describe '#ping' do
      it 'pongs' do
        expect(subject.ping).to eq('PONG')
      end
    end

    describe '#quit' do
      it 'closes connection' do
        expect(subject.quit).to eq true
        expect { subject.connection.read }.to raise_error(IOError)
        expect(subject.quit).to eq false
      end
    end
  end
end
