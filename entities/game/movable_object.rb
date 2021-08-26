# frozen_string_literal: true
module Entities
  module Game
    class MovableObject < GameObject
      include Traits::Environment

      def present
        raise "implement in subclass"
      end
    end
  end
end
