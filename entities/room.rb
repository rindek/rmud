# frozen_string_literal: true
module Entities
  class Room < ImmovableObject
    option :short, type: Types::String
    option :long, type: Types::String
    option :exits, type: Types::Array.of(Types.Instance(Entities::RoomExit))

    include Traits::Inventory
  end
end
