# frozen_string_literal: true
module Engine
  class Client
    extend Dry::Initializer
    include Dry::Monads[:try, :maybe]

    option :em_connection
    option :default_handler, default: -> { Engine::Handlers::Login }
    option :queue, default: -> { [] }
    option :process_command, default: -> { Engine::ProcessCommand.new }

    def close
      em_connection.close_connection_after_writing
    end

    def write(msg)
      em_connection.send_data(msg)
    end

    ## triggered from EM
    def receive_data(data)
      process_command.call(input: (queue << data.chomp).shift, handler: current_handler, client: self)
    end

    def read_client
      # asynchronously wait for this variable to be set by next
      # received data, name of method is for simplicity when
      # implementing
      process_command.aquire_lock!
    end

    def handler=(new_handler)
      @current_handler = new_handler
    end

    def current_player
      Maybe(current_handler).fmap { |handler| handler.try(:player) }.bind do |player|
        Entities::Game::Player.try(player).to_monad.to_maybe
      end
    end

    def current_handler
      @current_handler ||= default_handler.new
    end

    private
  end
end
