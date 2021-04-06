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

App[:rooms].register("spawn", memoize: true) do
  World::SpecialRoom.new(
    id: BSON::ObjectId.new,
    short: "a spawn room short",
    long: "a spawn room long",
    exits: [Entities::RoomExit.new(to: Repos::Rooms.new.first.value!.id, name: "wyjscie")],
    objects: [Entities::Reference.new(type: "player", id: "rindek")],
  )
end
