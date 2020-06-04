# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      def self.load!(container)
        Models::Room.eager(:exits).all.each do |room|
          container.register(room.link, memoize: true) do
            Entities::Room.new(
              short: room.short,
              long: room.long,
              exits: room.exits.map(&:to_entity),
            )
          end
        end
      end
    end
  end
end
