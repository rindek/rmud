# frozen_string_literal: true
module Engine
  module Events
    module Rooms
      class AfterEnter < Engine::Events::Base
        Schema =
          Dry::Schema.Params do
            required(:who).filled(Types::Game::Player)
            required(:to_room).filled(Types::Game::Room)
          end

        def execute(who:, to_room:)
          to_room.inventory.players(without: who).each { |player| player.write("%s przybywa.\n" % who.present) }
          Maybe(to_room.callbacks[:after_enter]).bind { |c| c.(who) }

          Success()
        end
      end
    end
  end
end
