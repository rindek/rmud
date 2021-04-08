# frozen_string_literal: true
module Engine
  module Commands
    class Game
      extend Dry::Container::Mixin

      register(:zakoncz) { |player:| Engine::Command::Game::Zakoncz.new(player: player) }
      register(:spojrz) { |player:| Engine::Command::Game::Spojrz.new(player: player) }
      register(:powiedz) { |player:| Engine::Command::Game::Powiedz.new(player: player) }
    end
  end
end
