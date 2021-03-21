# frozen_string_literal: true
module Engine
  module Command
    class Login < Base
      include Concurrent
      include Import["repos.players"]

      def call(name)
        player = yield find_player(name)
        password = yield get_password

        yield authenticate(player, password)

        PLAYERS[name] = player

        client.handler = Engine::Handlers::Game.new(client: client, tp: player)
        yield spawn(player)

        write_client("Zalogowano!\n")
        client.receive_data("spojrz")

        Success(player)
      end

      private

      def find_player(name)
        players.new.find_by(name: name).or { Failure("Nie ma takiego gracza #{name}.\n") }
      end

      def get_password
        write_client("Podaj haslo: ")
        Success(client.read_client)
      end

      def authenticate(player, password)
        BCrypt::Password.new(player.password) == password ? Success(true) : Failure("Niepoprawne haslo.\n")
      end

      def spawn(entity)
        room = App[:rooms].resolve("spawn")
        entity.move(to: room)
      end
    end
  end
end
