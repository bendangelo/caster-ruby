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
        if connected?
          # fixes server error if already disconnected
          execute_silent('QUIT')
          connection.disconnect
          return true
        end

        return false
      end

      def close
        quit
      end

      def connected?
        connection.connected?
      end

      private

      def execute_json(command, hash)
        connection.write("#{command} #{hash.to_json}")
        yield if block_given?
        type_cast_response(connection.read)
      end

      def execute_silent(*args)
        connection.write(*args.join(' '))
        yield if block_given?
      end

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
