# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      def self.load!(container = Dry::Container.new)
        Repos::Room.new.each_with_exits { |room| container.register(room.id, memoize: true) { room } }
        container
      end
    end
  end
end
