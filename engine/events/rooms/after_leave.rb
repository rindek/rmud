# frozen_string_literal: true
module Engine
  module Events
    module Rooms
      class AfterLeave < Engine::Events::Base
        Schema =
          Dry::Schema.Params do
            required(:who).filled(Types::Game::Player)
            required(:from).filled(Types::Game::Room)
            required(:to_exit).filled(Types::Game::RoomExit)
          end

        def execute(who:, from:, to_exit:)
          from
            .inventory
            .players(without: who)
            .each { |player| player.write("%s podąża %s %s.\n" % [who.present, to_exit.joiner, to_exit.name]) }

          Maybe(from.callbacks[:after_leave]).bind { |c| c.(who) }

          Success()
        end
      end
    end
  end
end
