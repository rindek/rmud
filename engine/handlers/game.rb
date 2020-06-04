# frozen_string_literal: true
module Engine
  module Handlers
    class Game
      extend Dry::Initializer

      option :client, type: Types.Instance(Engine::Client)
      option :tp, type: Types::PlayerObject

      option :commands, default: -> { Engine::Commands::Game }

      def receive(message)
        cmd, *args = message.split

        commands.resolve(String(cmd).to_sym).(client: client, tp: tp).(*args)
          .or { |msg| client.write(msg) }
      rescue Dry::Container::Error => e
        raise(e) unless e.message.match(/Nothing registered with the key/)

        client.write("Slucham?\n")
      end
    end
  end
end
