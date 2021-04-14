# frozen_string_literal: true
module Engine
  module Commands
    class Game
      extend Dry::Container::Mixin
      extend Engine::Command::Game::Mixin

      register_command(
        :powiedz,
        ->(player, *args) do
          Engine::Events::Speak.call(who: player, what: args.join(" "), where: player.current_environment)
        end,
      )
      register_command(:zakoncz, ->(player, _) { shutdown.call(player: player) }, ["lib.shutdown"])

      register(:spojrz) { |player:| Engine::Command::Game::Glance.new(player: player) }
    end
  end
end
