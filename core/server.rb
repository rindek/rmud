require_relative "engine"

class Rmud
  class Server
    attr_accessor :connections

    def initialize
      @connections = []
    end

    def start
      @sig = EventMachine.start_server('localhost', '4001', RmudConnector) do |connection|
        connections << connection
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
      if connections.empty?
        EventMachine.stop
      else
        puts "Waiting for #{connections.size} connection(s) to finish ..."
      end
    end
  end
end
