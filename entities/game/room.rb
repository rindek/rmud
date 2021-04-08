# frozen_string_literal: true
module Entities
  module Game
    class Room < ImmovableObject
      attribute :id, Types::String
      attribute :short, Types::String
      attribute :long, Types::String
      attribute :exits, Types::Array.of(Types.Entity(Entities::Game::RoomExit))

      include Traits::Inventory
    end
  end
end
