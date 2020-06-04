# frozen_string_literal: true
module Engine
  module Command
    class Login < Base
      include Concurrent

      def call(name)
        model = yield find_player(name)
        password = yield get_password

        sleep(1)

        yield authenticate(model, password)

        puts name
        puts password

        puts "Yes"

        tp.reset!

        Success()

        # entity = Entities::Player.new(model: model, origin: tp)
        # switch_handler(Engine::Handlers::Game)
        # yield spawn(entity)

        # Success(entity)
      end

      private

      def find_player(name)
        Maybe(Models::Player.where(name: name).first).to_result
          .or { Failure("Nie ma takiego gracza #{name}.\n") }
      end

      def get_password
        write_client("Podaj haslo: ")
        tp.wait!
        Success(tp.ivar.value)
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

      def spawn(entity)
        room = ROOMS.resolve("1")
        entity.move(to: room)
      end
    end
  end
end
