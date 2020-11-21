# frozen_string_literal: true
module Engine
  module Commands
    class Game
      extend Dry::Container::Mixin

      register(:zakoncz) { |**args| Engine::Command::Zakoncz.new(**args) }
      register(:spojrz) { |**args| Engine::Command::Spojrz.new(**args) }
    end
  end
end
