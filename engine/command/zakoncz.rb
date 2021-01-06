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
        tp.environment.remove_from_inventory
      end
    end
  end
end
