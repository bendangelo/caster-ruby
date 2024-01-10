module Caster
  class Client
    def initialize(host, port, password = nil, read_timeout = 5)
      @host = host
      @port = port
      @password = password
      @read_timeout = read_timeout
    end

    def channel(type)
      channel_class(type).new(Connection.connect(@host, @port, type, @password, @read_timeout))
    end

    private

    def channel_class(type)
      case type.to_sym
      when :control then Channels::Control
      when :ingest then Channels::Ingest
      when :search then Channels::Search
      else raise ArgumentError, "`#{type}` channel type is not supported"
      end
    end
  end
end
