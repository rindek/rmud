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

          App[:events].publish(
            "players.room.left",
            player: player,
            from_room: player.current_environment,
            to_exit: rexit,
          )

          yield Engine::Actions::Move.call(object: player, dest: rexit.room)
          client.write("Podążasz %s %s.\n" % [rexit.joiner, rexit.name])

          App[:events].publish("players.room.entered", player: player, to_room: rexit.room)

          player.client.receive_data("spojrz", write_prompt: false)

          Success()
        end
      end
    end
  end
end
