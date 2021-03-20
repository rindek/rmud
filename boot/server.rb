# frozen_string_literal: true
App.boot(:server) do
  start do
    Thread.new do
      EventMachine.run do
        EventMachine.start_server App[:settings].host, App[:settings].port, Engine::Server
        puts "Now accepting connections on address #{App[:settings].host} port #{App[:settings].port}..."
      end
    end
  end
end
