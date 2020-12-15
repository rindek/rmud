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

ROOMS.register("special", memoize: true) do
  World::SpecialRoom.new(
    short: "a special short",
    long: "a special long",
    exits: [Entities::RoomExit.new(id: "2", name: "wschod")],
  )
end
