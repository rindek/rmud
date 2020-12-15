# frozen_string_literal: true
module Engine
  module Command
    class Zakoncz < Base
      def call
        move_to_void if tp
        client.close

        Success
      end

      private

      def move_to_void
        tp.environment.inventory.remove(tp)
        tp.environment = nil
      end
    end
  end
end
