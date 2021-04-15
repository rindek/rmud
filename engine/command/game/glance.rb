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
          items = room.inventory.items.map(&:present)

          client.write("#{room.short}\n")
          client.write("#{composite(players)}.\n") unless players.empty?
          client.write("#{composite(items)}.\n") unless items.empty?
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
end
