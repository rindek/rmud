# frozen_string_literal: true
module Engine
  module Command
    class Zakoncz < Base
      def call
        tp.close
        Success()
      end
    end
  end
end
