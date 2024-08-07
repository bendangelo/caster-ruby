module Caster
  class Error < StandardError; end
  class ServerError < Error; end
  class ConnectionExpired < Error; end
  class AuthenticationError < Error; end
  class ConnectionRefused < Error; end
end
