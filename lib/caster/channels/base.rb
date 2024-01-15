module Caster
  module Channels
    class Base
      attr_reader :connection

      def initialize(connection)
        @connection = connection
      end

      def ping
        execute('PING')
      end

      def help(manual)
        execute('HELP', manual)
      end

      def quit
        if connection.connected?
          execute('QUIT')
          connection.disconnect
          return true
        end

        connection&.disconnect

        return false
      end

      def close
        quit
      end

      def connected?
        connection.connected?
      end

      private

      def execute(*args)
        connection.write(*args.join(' '))
        yield if block_given?
        type_cast_response(connection.read)
      end

      def sanitize(value)
        # remove backslashes entirely
        value.gsub(/\\/, "").gsub(/[\r\n]+/, '\\n')
      end

      def type_cast_response(value)
        if value == 'OK'
          true
        elsif value.start_with?('RESULT ')
          value.split(' ').last.to_i
        elsif value.start_with?('EVENT ')
          value.split(' ')[2..-1]
        else
          value
        end
      end
    end
  end
end
