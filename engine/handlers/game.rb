# frozen_string_literal: true
module Engine
  module Handlers
    class Game
      extend Dry::Initializer

      option :player, type: Types::Game::Player
      option :commands, default: -> { Engine::Commands::Game }

      delegate :client, to: :player

      def receive(message)
        cmd, *args = message.split

        commands.resolve(String(cmd).to_sym).(player: player).(*args).or { |msg| client.write(msg) }
      rescue Dry::Container::Error => e
        raise(e) unless e.message.match(/Nothing registered with the key/)

        client.write("Slucham?\n")
      end

      def prompt
        "game> "
      end
    end
  end
end
