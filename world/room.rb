require 'core/room.rb'

require 'world/room2'

module World
  class Room < Core::Room
    def initialize
      super()

      @short = "przykladowy pokoj 1"

      add_exit('polnoc', World::Room2)
      add_exit('niestandardowe', World::Room2)

      add_object_action(:test, "test")
    end

    def test(command)
      this_player.catch_msg("test")
    end
  end
end