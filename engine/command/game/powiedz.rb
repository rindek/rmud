# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Powiedz < Base
        def call(*arg)
          to_say = arg.join(" ")
          client.write("Mowisz: #{to_say}\n")

          player
            .current_environment
            .inventory
            .players(without: player)
            .each { |pl| pl.write("#{player.name} mowi: #{to_say}\n") }

          Success(true)
        end
      end
    end
  end
end
