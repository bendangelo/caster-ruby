require 'pry'
lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caster'

Dir['./spec/support/**/*.rb'].each { |f| require f }
