# frozen_string_literal: true
module Engine
  module Handlers
    class Login
      extend Dry::Initializer

      param :tp, type: Types.Instance(Engine::Player)
      option :commands, default: -> { Engine::Commands::Login }

      def receive(message)
        cmd, *args = message.split

        commands.resolve(String(cmd).to_sym).(tp).(*args)
      rescue Dry::Container::Error => e
        raise unless e.message.match(/Nothing registered with the key/)
        tp.write(e.message + "\n")
      end
    end
  end
end
