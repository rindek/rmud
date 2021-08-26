# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Glance < Base
        def call(...)
          present(yield fetch_room)
          Success(true)
        end

        private

        def fetch_room
          Types::Game::Room
            .try(player.current_environment)
            .to_monad
            .or { Failure("Nie znajdujesz sie w pomieszczeniu.\n") }
        end

        def present(room)
          players = room.inventory.players(without: player).map(&:present)
          creatures = room.inventory.creatures.map(&:present)
          items = room.inventory.items.map(&:present)

          client.write("#{room.short}\n")
          client.write("#{composite(players + creatures)}.\n") if [players, creatures].any? { |x| !x.empty? }
          client.write("#{composite(items)}.\n") unless items.empty?
          client.write("Wyjscia: #{room.exits.map(&:name).join(", ")}\n")
        end

        def composite(words)
          first, second, *rest = words

          if rest.empty?
            [first, second].compact.join(" i ")
          else
            [[first, second].join(", "), rest].join(" i ")
          end.capitalize
        end
      end
    end
  end
end
