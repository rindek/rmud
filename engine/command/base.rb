# frozen_string_literal: true
module Engine
  module Command
    class Base
      extend Dry::Initializer
      include Dry::Monads[:result, :do, :maybe]

      param :tp, type: Types.Instance(Engine::Player)

      private

      def write_client(msg)
        tp.write(msg)
      end

      def read_client
        tp.client.tcpsocket.gets.chomp
      end
    end
  end
end
