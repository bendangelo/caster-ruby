require 'spec_helper'

module Caster
  module Channels
    RSpec.describe Search do
      include_examples 'channel'

      subject { client.channel(:search) }

      let(:collection) { 'collection' }
      let(:bucket) { 'bucket' }
      let(:object) { 'object' }
      let(:terms) { 'terms' }
      let(:lang) { :eng }
      let(:attrs) { [1, 2] }

      before do
        client.channel(:ingest).push(collection, bucket, object, terms, lang: lang, attrs: attrs)
        client.channel(:control).trigger('consolidate')
      end

      describe '#query' do
        it 'returns proper object' do
          expect(subject.query(collection, bucket, terms)).to eq [object]
        end

        it 'returns proper object by order' do
          expect(subject.query(collection, bucket, terms, order: 1)).to eq [object]
        end

        it 'returns proper object by less than' do
          expect(subject.query(collection, bucket, terms, less_than: [0, 2])).to eq [object]
        end

        it 'returns proper object by greater than' do
          expect(subject.query(collection, bucket, terms, greater_than: [1, 1])).to eq [object]
        end

        it 'returns proper object by equal than' do
          expect(subject.query(collection, bucket, terms, equal: [0, 1])).to eq [object]
        end

        it 'returns proper object ordered by ASC 0' do
          expect(subject.query(collection, bucket, terms, order: 0, dir: 0)).to eq [object]
        end
      end

      describe.pending '#suggest' do
        it 'suggest proper terms' do
          expect(subject.suggest(collection, bucket, terms[0..-2])).to eq(terms)
        end
      end
    end
  end
end
