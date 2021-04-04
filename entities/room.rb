# frozen_string_literal: true
module Entities
  class Room < ImmovableObject
    attribute :id, Types::BSON
    attribute :short, Types::String
    attribute :long, Types::String

    attribute :exits, Types::Array.of(Types.Entity(Entities::RoomExit))

    include Traits::Inventory
  end
end
