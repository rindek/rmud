# frozen_string_literal: true
module Engine
  module Commands
    class Game
      extend Dry::Container::Mixin

      register(:zakoncz) { |tp, po| Engine::Command::Zakoncz.new(tp, po) }
    end
  end
end
