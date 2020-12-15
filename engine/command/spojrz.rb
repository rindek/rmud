# frozen_string_literal: true
module Engine
  module Command
    class Spojrz < Base
      def call
        present(yield fetch_room)
        Success
      end

      private

      def fetch_room
        Types::Room.try(tp.environment).to_monad.or { Failure("Nie znajdujesz sie w pomieszczeniu.\n") }
      end

      def present(room)
        client.write("#{room.short}\n")
        client.write("Wyjscia: #{room.exits.map(&:name).join(", ")}\n")
      end
    end
  end
end
