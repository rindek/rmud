# frozen_string_literal: true
module Models
  class RoomExit < Sequel::Model(:room_exits)
    many_to_one :from, key: :from_room_id, class: :"Models::Room"
    many_to_one :to, key: :to_room_id, class: :"Models::Room"

    def to_entity
      Entities::RoomExit.new(
        id: String(to_room_id),
        name: name,
      )
    end
  end
end
