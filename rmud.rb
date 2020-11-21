require "./boot"

# engine = Engine::Server.new
# Thread.new { engine.start! }

Thread.new do
  EventMachine.run do
    port = 2300
    EventMachine.start_server "0.0.0.0", port, Engine::Server
    puts "Now accepting connections on address port #{port}..."
  end
end

binding.pry
