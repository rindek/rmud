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
          players = room.inventory.players(without: player)
          creatures = room.inventory.creatures
          items = room.inventory.items

          client.pwrite(room.short)
          if [players, creatures].any? { |x| !x.empty? }
            client.pwrite(Mudlib::Decorate.call(objects: players + creatures, observer: player))
          end

          # client.write(players + creatures) if [players, creatures].any? { |x| !x.empty? }
          client.write(items) unless items.empty?
          client.write("Wyjscia: #{room.exits.map(&:name).join(", ")}\n")
        end
      end
    end
  end
end
