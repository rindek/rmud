require_relative "engine"

class Rmud
  class Server
    attr_accessor :connections

    def initialize
      @connections = []
    end

    def start
      Engine.instance.load_all
      load_world
      server_config = read_config("game")[Rmud.env]

      log_notice("[server.rb] - accepting connections on #{server_config["host"]}:#{server_config["port"]}")
      @sig = EventMachine.start_server(server_config["host"], server_config["port"], RmudConnector) do |connection|
        @connections << connection
        connection.server = self
      end
    end

    def stop
      EventMachine.stop_server(@sig)
      connections.map(&:disconnect)

      unless wait_for_connections_and_stop
        EventMachine.add_periodic_timer(1) { wait_for_connections_and_stop }
      end
    end

    def wait_for_connections_and_stop
      if @connections.empty?
        EventMachine.stop
      else
        puts "Waiting for #{@connections.size} connection(s) to finish ..."
      end
    end
  end
end
