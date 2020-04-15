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
          .or { |msg| tp.write(msg) }
      rescue Dry::Container::Error => e
        raise(e) unless e.message.match(/Nothing registered with the key/)

        ## Try to login
        commands.resolve(:_login).(tp).(cmd)
          .or { |msg| tp.writeln(msg) }
      end
    end
  end
end
