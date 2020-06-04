# frozen_string_literal: true
module Engine
  module Handlers
    class Login
      extend Dry::Initializer

      option :client, type: Types.Instance(Engine::Client)
      option :commands, default: -> { Engine::Commands::Login }

      def receive(message)
        cmd, *args = message.split

        commands.resolve(String(cmd).to_sym).(client: client).(*args)
          .or { |msg| client.write(msg) }
      rescue Dry::Container::Error => e
        raise(e) unless e.message.match(/Nothing registered with the key/)

        commands.resolve(:_login).(client: client).(cmd)
          .or { |msg| client.write(msg) }
      end
    end
  end
end
