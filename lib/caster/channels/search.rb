module Caster
  module Channels
    class Search < Base
      def query(collection, bucket, terms, limit: nil, offset: nil, lang: nil, greater_than: nil, less_than: nil, equal: nil, order: nil, order_attr: nil) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
        arr = [collection, bucket]
        arr << "LIMIT #{limit}" if limit
        arr << "OFFSET #{offset}" if offset
        arr << "LANG #{lang}" if lang
        arr << "EQ #{equal[0]},#{equal[1]}" if equal
        arr << "LT #{less_than[0]},#{less_than[1]}" if less_than
        arr << "GT #{greater_than[0]},#{greater_than[1]}" if greater_than
        arr << offset.to_s.upcase if order
        arr << order_attr.to_s if order_attr
        arr << "-- #{sanitize(terms)}"

        execute('QUERY', *arr) do
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
