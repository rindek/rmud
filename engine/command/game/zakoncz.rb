# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Zakoncz < Base
        include Import["lib.shutdown"]

        def call(...)
          shutdown.call(player: player)
        end
      end
    end
  end
end
