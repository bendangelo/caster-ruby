module Caster
  RSpec.shared_context 'client' do
    let(:client) { Client.new(host, port, password) }
    let(:host) { 'localhost' }
    let(:port) { 1491 }
    let(:password) { 'caster' }
  end
end
