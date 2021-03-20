# frozen_string_literal: true
module Engine
  module Command
    class Zakoncz < Base
      def call
        clean_up if tp
        client.close

        Success(true)
      end

      private

      def clean_up
        tp.remove_self_from_inventory
        PLAYERS.delete(tp.model.name)
      end
    end
  end
end
