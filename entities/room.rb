# frozen_string_literal: true
module Entities
  class Room < ImmovableObject
    attribute :short, Types::String
    attribute :long, Types::String
    attribute :exits, Types::Array.of(Types.Instance(Entities::RoomExit))

    include Traits::Inventory
  end
end
