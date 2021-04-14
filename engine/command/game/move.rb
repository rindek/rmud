# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Move < Base
        def call(rexit:)
          yield (
            Types
              .Instance(Entities::Game::RoomExit)
              .try(rexit)
              .to_monad
              .or { Failure("Jakaś magiczna siła nie pozwala ci iść w tym kierunku.\n") }
          )

          current_environment = player.current_environment

          Engine::Events::Rooms::BeforeLeave.call(who: player, from: current_environment, to_exit: rexit)
          Engine::Events::Rooms::BeforeEnter.call(who: player, to_room: rexit.room)

          yield Engine::Actions::Move.call(object: player, dest: rexit.room)

          Engine::Events::Rooms::AfterEnter.call(who: player, to_room: rexit.room)
          Engine::Events::Rooms::AfterLeave.call(who: player, from: current_environment, to_exit: rexit)

          player.client.receive_data("spojrz", write_prompt: false)

          Success()
        end
      end
    end
  end
end
