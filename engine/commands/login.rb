# frozen_string_literal: true
module Engine
  module Commands
    class Login
      extend Dry::Container::Mixin

      register(:zakoncz) { |client:| Engine::Command::Login::Zakoncz.new(client: client) }
      register(:_login) { |client:| Engine::Command::Login::Login.new(client: client) }
    end
  end
end
