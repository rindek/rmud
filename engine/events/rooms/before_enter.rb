# frozen_string_literal: true
module Engine
  module Events
    module Rooms
      class BeforeEnter < Engine::Events::Base
        Schema =
          Dry::Schema.Params do
            required(:who).filled(Types::Game::Player)
            required(:to_room).filled(Types::Game::Room)
          end

        def execute(who:, to_room:)
          Maybe(to_room.callbacks[:before_enter]).bind { |c| c.(who) }

          Success()
        end
      end
    end
  end
end
