# frozen_string_literal: true
module Engine
  class Client
    extend Dry::Initializer

    option :tcpsocket, type: Types.Instance(TCPSocket)
    option :handler, default: -> { Engine::Handlers::Login }

    delegate :close, :write, to: :tcpsocket

    def listen
      loop do
        handler.new(tp).receive(tcpsocket.gets.chomp)
        break if tcpsocket.closed?
      end
    end

    private

    def tp
      @tp ||= Engine::Player.new(client: self)
    end
  end
end
