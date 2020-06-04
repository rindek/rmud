require "./boot"

# engine = Engine::Server.new
# Thread.new { engine.start! }

Thread.new do
  EventMachine.run do
    EventMachine.start_server "0.0.0.0", 2300, Engine::Server
  end
end

binding.pry
