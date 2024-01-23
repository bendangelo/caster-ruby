require 'spec_helper'

module Caster
  module Channels
    RSpec.describe Ingest do
      include_examples 'channel'

      subject { client.channel(:ingest) }

      let(:collection) { 'collection' }
      let(:bucket) { 'bucket' }
      let(:object) { 'object' }
      let(:text) { 'text' }

      describe '#push' do
        it 'returns true' do
          expect(subject.push(collection: collection, bucket: bucket, object: object, text: text)).to eq(true)
        end

        it 'accepts attr' do
          attrs = [1, 1]
          expect(subject.push(collection: collection, bucket: bucket, object: object, text: text, attrs: attrs)).to eq(true)
        end

        it 'accepts keywords' do
          keywords = "extra keywods"
          expect(subject.push(collection: collection, bucket: bucket, object: object, text: text, keywords: keywords)).to eq(true)
        end

        it 'accepts headers' do
          headers = "channel name"
          expect(subject.push(collection: collection, bucket: bucket, object: object, text: text, headers: headers)).to eq(true)
        end

        it 'accepts lang' do
          lang = :eng
          expect(subject.push(collection: collection, bucket: bucket, object: object, text: text, lang: lang)).to eq(true)
        end

        it 'returns buffer overflow' do
          text = "1" * 20_000
          expect{ subject.push(collection: collection, bucket: bucket, object: object, text: text) }.to raise_error ServerError
        end
      end

      describe.skip '#pop' do
        it 'returns a number' do
          expect(subject.pop(collection, bucket, object, text))
            .to be_an(Integer)
        end
      end

      describe '#count' do
        it 'returns a number' do
          expect(subject.count(collection, bucket, object)).to be_an(Integer)
        end
      end

      describe '#flushc' do
        it 'returns a number' do
          expect(subject.flushc(collection)).to be_an(Integer)
        end
      end

      describe '#flushb' do
        it 'returns a number' do
          expect(subject.flushb(collection, bucket)).to be_an(Integer)
        end
      end

      describe '#flusho' do
        it 'returns a number' do
          expect(subject.flusho(collection, bucket, object)).to be_an(Integer)
        end
      end
    end
  end
end
