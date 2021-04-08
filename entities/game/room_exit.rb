# frozen_string_literal: true
module Entities
  module Game
    class RoomExit < Abstract
      attribute :to, Types.Resolvable(:rooms)
      attribute :name, Types::String

      def room
        to.()
      end
    end
  end
end
