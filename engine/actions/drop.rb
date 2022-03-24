module Engine
  module Actions
    class Drop < Abstract
      include Import["core"]

      Schema =
        Dry::Schema.Params do
          required(:item).filled(Types::Game::MovableObject)
          required(:player).filled(Types::Game::Player)
        end

      def execute(item:, player:)
        yield Engine::Actions::Unwield.call(weapon: item, player: player) if core.weapon?(item)
        yield Engine::Actions::Move.call(object: item, dest: player.current_environment)

        Success(item)
      end
    end
  end
end
