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
        # binding.pry
        # Maybe(tp.client.em_connection.send(:gets))
        #   .to_result
        #   .fmap { |msg| msg.chomp }
        #   .or { Failure("Polaczenie zostalo zerwane\n") }
      end
    end
  end
end
