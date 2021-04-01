# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      include Import["repos.rooms"]

      def self.load!(container = Dry::Container.new)
        new.rooms.all_by({}).fmap { |rooms| rooms.each { |room| container.register(room.id, memoize: true) { room } } }
        container
      end
    end
  end
end
