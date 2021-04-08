# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Zakoncz < Base
        def call(...)
          clean_up
          client.close

          Success(true)
        end

        private

        def clean_up
          player.remove_self_from_inventory
          PLAYERS.delete(player.name)
        end
      end
    end
  end
end
