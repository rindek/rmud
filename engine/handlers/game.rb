# frozen_string_literal: true
module Engine
  module Handlers
    class Game
      extend Dry::Initializer
      include Dry::Monads[:try, :result, :do, :maybe]

      option :player, type: Types::Game::Player
      option :commands, default: -> { Engine::Commands::Game }

      def receive(message, client)
        cmd, *args = message.split

        ## priority:
        ## room exits
        ## player inventory
        ## environment
        ## common commands
        Types::Game::Room
          .try(player.current_environment)
          .to_monad
          .bind do |room|
            Maybe(room.exits.find { |exit| exit.name == cmd }).bind do |rexit|
              return Engine::Command::Game::Move.new(player: player).call(rexit: rexit).or { |msg| client.write(msg) }
            end
          end

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
