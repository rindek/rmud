# # frozen_string_literal:
# ROOMS.register("special") do
#   class SpecialRoom < Engine::Rooms::Base
#   end
# end
module World
  class SpecialRoom < Entities::Room
    def action
      :test
    end
  end
end

ROOMS.register("spawn", memoize: true) do
  World::SpecialRoom.new(
    short: "a spawn room short",
    long: "a spawn room long",
    exits: [Entities::RoomExit.new(to_room_id: String(Repos::Room.new.first.value!.id), name: "wyjscie")],
  )
end
