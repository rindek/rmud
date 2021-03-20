# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      def self.load!(container)
        Repos::Room.new.each_with_exits { |room| container.register(room.id, memoize: true) { room } }
      end
    end
  end
end
