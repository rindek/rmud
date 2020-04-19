# frozen_string_literal: true
module Engine
  class Server
    def initialize
      @clients = []
      @server = TCPServer.open("localhost", "2300")
    end

    def start!
      mutex = Mutex.new
      loop do
        Thread.start(@server.accept) { |client| mutex.synchronize { new_client(client) } }
      end
    end

    def new_client(client)
      @clients.push(client)
      Engine::Client.new(tcpsocket: client).listen
    end

    #   puts "Starting server on localhost:2300"

    #   loop do
    #     Thread.start(@server.accept) do |client|
    #       puts "New connection"

    #       client.write("\nEnter your name\n")

    #       @clients.push(client)

    #       puts "Currently #{@clients.length} clients"

    #       loop do
    #         msg = client.gets.chomp
    #         client.write("Received message: #{msg}\n")

    #         if msg == "koniec"
    #           client.shutdown
    #           @clients.delete(client)

    #           puts "Currently #{@clients.length} clients"
    #           break
    #         end
    #       end
    #     end
    #   end
    # end
  end
end
