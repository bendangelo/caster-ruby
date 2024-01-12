module Caster
  class Connection
    def self.connect(*args)
      connection = new(*args)
      connection if connection.connect
    end

    def initialize(host, port, channel_type, password = nil, read_timeout = 5)
      @host = host
      @port = port
      @channel_type = channel_type
      @password = password
      @read_timeout = read_timeout
    end

    def connect
      socket.gets # get welcome message
      write(['START', @channel_type, @password].compact.join(' '))
      read.start_with?('STARTED ')
    end

    def disconnect
      socket&.close
      socket = nil
    end

    def connected?
      !socket.nil?
    end

    def read
      data = nil

      Timeout.timeout(@read_timeout) do
        # chomp to remove newline
        data = socket.gets&.chomp
      end

      raise ServerError.new("#{data.force_encoding('UTF-8')} (Command ran: #{@last_write})") if data.start_with?('ERR ')

      data
    rescue Timeout::Error
      raise ServerError.new("Response server timed out (Command ran: #{@last_write})")
    end

    def write(data)
      @last_write = data

      begin
        socket.puts(data)
      rescue Errno::EPIPE => error
        disconnect
        raise ConnectionExpired.new("Connection expired. Please reconnect.")
      end
    end


    private

    def socket
      @socket ||= begin
                    socket = TCPSocket.open(@host, @port, nil, nil)
                    # disables Nagle's Algorithm, prevents multiple round trips with MULTI
                    socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
                    socket
                  end
    end

  end
end
