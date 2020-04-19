# frozen_string_literal: true
module Models
  class Room < Sequel::Model(:rooms)
    one_to_many :exits, key: :from_room_id, class: :"Models::RoomExit"

    def link
      String(id)
    end
  end
end
