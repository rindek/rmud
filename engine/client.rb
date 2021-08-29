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
      # to_send =
      #   if msg.is_a?(String)
      #     msg
      #   elsif msg.is_a?(Array)
      #     msg.map { |obj| obj.decorator(observer: current_player) }.join(", ").capitalize + ".\n"
      #   elsif Types::Game::GameObject.try(msg).success?
      #     msg.decorator(observer: current_player).capitalize + ".\n"
      #   else
      #     "Error while sending message. Unknown type #{msg.inspect}\n"
      #   end

      # em_connection.send_data(to_send)
    end

    def pwrite(msg)
      write(msg.capitalize + ending(msg))
    end

    ## triggered from EM
    def receive_data(data, write_prompt: true)
      process_command.call(
        input: (queue << data.chomp).shift,
        handler: current_handler,
        client: self,
        write_prompt: write_prompt,
      )
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
      Maybe(current_handler)
        .fmap { |handler| handler.try(:player) }
        .bind { |player| Entities::Game::Player.try(player).to_monad.to_maybe }
    end

    def current_handler
      @current_handler ||= default_handler.new
    end

    private

    def ending(message)
      message.ends_with?(".") ? "\n" : ".\n"
    end
  end
end
