# frozen_string_literal: true
module Engine
  module Commands
    class Login
      extend Dry::Container::Mixin

      register(:zakoncz) { |tp| Engine::Command::Zakoncz.new(tp) }
      register(:_login) { |tp| Engine::Command::Login.new(tp) }
    end
  end
end
