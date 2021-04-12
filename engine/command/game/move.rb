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

          previous_room = player.current_environment
          yield Engine::Actions::Move.call(object: player, dest: rexit.room)
          client.write("Podążasz %s %s.\n" % [rexit.joiner, rexit.name])
          previous_room
            .inventory
            .players
            .each { |pl| pl.write("%s podąża %s %s.\n" % [player.name, rexit.joiner, rexit.name]) }
          player
            .current_environment
            .inventory
            .players(without: player)
            .each { |pl| pl.write("%s przybywa.\n" % [player.name]) }

          player.client.receive_data("spojrz", write_prompt: false)

          Success()
        end
      end
    end
  end
end
