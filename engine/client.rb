# frozen_string_literal: true
module Engine
  class Client
    extend Dry::Initializer

    option :tcpsocket, type: Types.Instance(TCPSocket)
    option :handler, default: -> { Engine::Handlers::Login }

    def listen
      loop { handler.new(self).receive(tcpsocket.gets.chomp) }
    end
  end
end
