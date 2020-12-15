# frozen_string_literal: true
module Engine
  module Command
    class Login < Base
      include Concurrent

      def call(name)
        model = yield find_player(name)
        password = yield get_password

        yield authenticate(model, password)

        entity = Entities::Player.new(model: model)
        client.handler = Engine::Handlers::Game.new(client: client, tp: entity)
        yield spawn(entity)

        write_client("Zalogowano!\n")
        client.receive_data("spojrz")

        Success(entity)
      end

      private

      def find_player(name)
        Maybe(Models::Player.where(name: name).first).to_result.or { Failure("Nie ma takiego gracza #{name}.\n") }
      end

      def get_password
        write_client("Podaj haslo: ")
        Success(client.read_client)
      end

      def authenticate(player, password)
        BCrypt::Password.new(player.password) == password ? Success(true) : Failure("Niepoprawne haslo.\n")
      end

      def spawn(entity)
        room = ROOMS.resolve("spawn")
        entity.move(to: room)
      end
    end
  end
end
