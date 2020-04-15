# frozen_string_literal: true
module Engine
  class Client
    extend Dry::Initializer

    option :tcpsocket, type: Types.Instance(TCPSocket)
    option :handler, default: -> { Engine::Handlers::Login }

    delegate :close, :write, to: :tcpsocket

    def listen
      loop do
        begin
          handler.new(tp).receive(tcpsocket.gets.chomp)
        rescue => e
          # TODO - rollbar
          puts Backtrace.new(e)
          write("Wystapil powazny blad.\n")
        end

        break if tcpsocket.closed?
      end
    end

    private

    def tp
      @tp ||= Engine::Player.new(client: self)
    end
  end
end
