# frozen_string_literal: true
module Engine
  module Command
    class Login < Base
      def call(name)
        player = yield find_player(name)
        # Failure("Nie ma takiego gracza #{name}.\n")
      end

      private

      def find_player(name)
        Maybe(Models::Player.where(name: name).first).to_monad
          .or { Failure("Nie ma takiego gracza #{name}.") }
      end
    end
  end
end
