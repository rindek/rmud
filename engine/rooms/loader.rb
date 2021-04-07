# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      include Import["repos.rooms"]

      def self.load!(container = App[:game])
        new.rooms.each { |room| container.namespace(:rooms) { register(room.id, memoize: true) { room } } }
      end
    end
  end
end
