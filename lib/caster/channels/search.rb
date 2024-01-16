module Caster
  module Channels
    class Search < Base
      def query(collection, bucket, q, opts = {}) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
        arr = {
          collection: collection,
          bucket: bucket,
          q: q,
        }.merge opts

        execute_json('QUERY', arr) do
          # connection.read # ...
        end
      end

      def suggest(collection, bucket, word, limit = nil)
        arr = [collection, bucket]
        arr << "LIMIT #{limit}" if limit
        arr << "-- #{sanitize(word)}"

        execute('SUGGEST', *arr) do
          # connection.read # ...
        end
      end

      def list(collection, bucket, limit = nil, offset = nil)
        arr = [collection, bucket]
        arr << "LIMIT #{limit}" if limit
        arr << "OFFSET #{offset}" if offset

        execute('LIST', *arr) do
          # connection.read # ...
        end
      end
    end
  end
end
