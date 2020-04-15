# frozen_string_literal: true
module Engine
  module Command
    class Zakoncz < Base
      def call
        tp.close
      end
    end
  end
end
