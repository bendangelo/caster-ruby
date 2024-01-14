module Caster
  module Channels
    class Ingest < Base
      def push(collection, bucket, object, text, lang = nil, attrs = nil)
        arr = [collection, bucket, object]
        arr << "LANG #{lang}" if lang
        arr << "ATTR #{attrs.join(",")}" if attrs
        arr << "-- #{sanitize(text)}"

        execute('PUSH', *arr)
      end

      def pop(collection, bucket, object, text)
        execute('POP', collection, bucket, object, sanitize(text))
      end

      def count(collection, bucket = nil, object = nil)
        execute('COUNT', *[collection, bucket, object].compact)
      end

      def flushc(collection)
        execute('FLUSHC', collection)
      end

      def flushb(collection, bucket)
        execute('FLUSHB', collection, bucket)
      end

      def flusho(collection, bucket, object)
        execute('FLUSHO', collection, bucket, object)
      end
    end
  end
end
