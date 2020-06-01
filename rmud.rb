require "./boot"

engine = Engine::Server.new
Thread.new { engine.start! }

binding.pry
