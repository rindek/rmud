require_relative "engine"

class Rmud
  class Server
    def self.start!
      Engine.instance.load_all
      $boot_time = Time.now

      EventMachine::run do
        load_world ## :-(

        server_config = read_config("game")[Rmud.env]
        log_notice("[server.rb] - accepting connections on #{server_config["host"]}:#{server_config["port"]}")

        EventMachine::start_server server_config["host"], server_config["port"], RmudConnector
      end
    end
  end
end
