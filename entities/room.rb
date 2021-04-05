# frozen_string_literal: true
module Entities
  class Room < Abstract
    attribute :id, Types::Coercible::String
    attribute :short, Types::String
    attribute :long, Types::String
    attribute :exits, Types::Array.of(Types.Entity(Entities::RoomExit))
    attribute :objects, Types::Array.of(Types.Entity(Entities::Reference))
  end
end
