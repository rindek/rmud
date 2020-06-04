# frozen_string_literal: true
module Engine
  module Command
    class Zakoncz < Base
      def call
        move_to_void if po
        tp.close

        Success()
      end

      private

      def move_to_void
        po.environment.inventory.remove(po)
        po.environment = nil
      end
    end
  end
end
