module Containers
  class Game
    extend Dry::Container::Mixin

    register(:rooms, Rooms)
    register(:items, Items)
    register(:npcs, NPCS)
  end
end
