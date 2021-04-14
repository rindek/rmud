# frozen_string_literal: true
module Engine
  module Events
    module Rooms
      class BeforeLeave < Engine::Events::Base
        Schema =
          Dry::Schema.Params do
            required(:who).filled(Types::Game::Player)
            required(:from).filled(Types::Game::Room)
            required(:to_exit).filled(Types::Game::RoomExit)
          end

        def execute(who:, from:, to_exit:)
          Maybe(from.callbacks[:before_leave]).bind { |c| c.(who) }

          Success()
        end
      end
    end
  end
end
