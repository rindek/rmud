# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      include Import["repos.rooms"]

      def self.load!(container = Dry::Container.new)
        new.rooms.each_with_exits { |room| container.register(room.id, memoize: true) { room } }
        container
      end
    end
  end
end
