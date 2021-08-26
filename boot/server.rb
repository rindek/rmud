# frozen_string_literal: true
App.boot(:server) do |app|
  start do
    use :requirements
    app[:loader].eager_load

    ## Load all world
    use :world

    puts "Warming up..."
    5.times { BCrypt::Password.create(SecureRandom.uuid) }

    Thread.new do
      EventMachine.run do
        EventMachine.start_server App[:settings].host, App[:settings].port, Engine::Server
        puts "Now accepting connections on address #{App[:settings].host} port #{App[:settings].port}..."
      end
    end
  end
end
