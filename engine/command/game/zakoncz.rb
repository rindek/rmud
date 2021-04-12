# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Zakoncz < Base
        def call(...)
          Engine::Lib::Shutdown.new(player: player).call
        end
      end
    end
  end
end
