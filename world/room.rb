# coding: utf-8

require './core/room.rb'

module World
  class Room < Core::Room
    def initialize
      super()

      @short = "przykladowy pokoj 1"

      add_exit('polnoc', World::Room2)
      add_exit('niestandardowe', World::Room2)

      add_object_action(:test, "test")

      Event.hook(self, 'object_entering_container') do |room, obj, from|
        if obj.is_a?(Player)
          obj.catch_msg("Ha, widzę, że przyszedłeś!\n")
        end
      end
    end

    def test(command)
      this_player.catch_msg("test")
    end
  end
end