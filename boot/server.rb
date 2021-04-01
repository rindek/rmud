# frozen_string_literal: true
App.boot(:server) do |app|
  start do
    use :requirements

    use :rooms

    app[:loader].eager_load

    Thread.new do
      EventMachine.run do
        EventMachine.start_server App[:settings].host, App[:settings].port, Engine::Server
        puts "Now accepting connections on address #{App[:settings].host} port #{App[:settings].port}..."
      end
    end
  end
end
