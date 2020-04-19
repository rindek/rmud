# frozen_string_literal: true
module Engine
  module Command
    class Login < Base
      def call(name)
        player = yield find_player(name)
        password = yield get_password

        yield authenticate(player, password)
        switch_handler(Engine::Handlers::Game)

        Success(player)
      end

      private

      def find_player(name)
        Maybe(Models::Player.where(name: name).first).to_result
          .or { Failure("Nie ma takiego gracza #{name}.\n") }
      end

      def get_password
        write_client("Podaj haslo: ")
        Success(read_client)
      end

      def authenticate(player, password)
        if BCrypt::Password.new(player.password) == password
          Success()
        else
          Failure("Niepoprawne haslo.\n")
        end
      end

      def switch_handler(handler)
        tp.client.handler = handler
        write_client("Zalogowany!\n")
      end
    end
  end
end
