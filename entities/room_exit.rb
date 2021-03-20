# frozen_string_literal: true
module Entities
  class RoomExit < Abstract
    attribute? :id, Types::Integer
    attribute :name, Types::String

    attribute? :from_room_id, Types::Integer.optional
    attribute :to_room_id, Types::String
  end
end
