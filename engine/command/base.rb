# frozen_string_literal: true
module Engine
  module Command
    class Base
      extend Dry::Initializer
      include Dry::Monads[:result, :do, :maybe]

      option :client, type: Types.Instance(Engine::Client)
      option :tp, type: Types::PlayerObject, optional: true

      private

      def write_client(msg)
        client.write(msg)
      end
    end
  end
end
