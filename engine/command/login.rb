# frozen_string_literal: true
module Engine
  module Command
    class Login < Base
      def call(name)
        # player = yield find_player(name)
        Failure("Nie ma takiego gracza #{name}\n")
      end
    end
  end
end
