# frozen_string_literal: true
module Entities
  class Room < Abstract
    attribute :id, Types::String
    attribute :short, Types::String
    attribute :long, Types::String
    attribute :exits, Types::Array.of(Types.Entity(Entities::RoomExit))
  end
end
