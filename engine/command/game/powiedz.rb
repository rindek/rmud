# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Powiedz < Base
        def call(*arg)
          Engine::Events::Speak.call(who: player, what: arg.join(" "), where: player.current_environment)
        end
      end
    end
  end
end
