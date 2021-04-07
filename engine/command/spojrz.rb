# frozen_string_literal: true
module Engine
  module Command
    class Spojrz < Base
      def call(...)
        present(yield fetch_room)
        Success(true)
      end

      private

      def fetch_room
        Types::Room.try(tp.current_environment).to_monad.or { Failure("Nie znajdujesz sie w pomieszczeniu.\n") }
      end

      def present(room)
        inventory_items = room.inventory.items.reject { |item| item == tp }.map(&:presentable)

        client.write("#{room.short}\n")
        client.write("#{composite(inventory_items)}.\n") unless inventory_items.empty?
        client.write("Wyjscia: #{room.exits.map(&:name).join(", ")}\n")
      end

      def composite(words)
        case words
        in first, second
          [first, second].join(" i ")
        in first, second, *rest
          [[first, second].join(", "), rest].join(" i ")
        else
          words.first
        end
      end
    end
  end
end
