# frozen_string_literal: true
module Engine
  module Rooms
    class Loader
      def self.load!(container)
        Models::Room.eager(:exits).all.each do |room|
          container.register(room.link) do
            Engine::Rooms::Base.new(
              short: room.short,
              long: room.long,
              exits: room.exits.map(&:link),
            )
          end
        end
      end
    end
  end
end
