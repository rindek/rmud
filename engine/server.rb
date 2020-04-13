# frozen_string_literal: true
module Engine
  class Server
    def initialize
      @clients = []
      @server = TCPServer.open("localhost", "2300")
    end

    def start!
      puts "Starting server on localhost:2300"

      loop do
        Thread.start(@server.accept) do |client|
          puts "New connection"

          client.write("hello")

          @clients.push(client)

          puts "Currently #{@clients.length} clients"

          loop do
            msg = client.gets.chomp
            client.write("Received message: #{msg}\n")

            if msg == "koniec"
              client.shutdown
              @clients.delete(client)

              puts "Currently #{@clients.length} clients"
              break
            end
          end
        end
      end
    end
  end
end
