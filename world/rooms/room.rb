# coding: utf-8
class Room < Std::Room

  ROOMS_PATH = World::Rooms
    
  def initialize
    super()

    @short = "przykladowy pokoj 1"

    add_exit('polnoc', ROOMS_PATH::Room2)
    add_exit('niestandardowe', "/world/rooms/room2")
    add_exit('dimm', '/world/averland/dimm/lokacje/wioska1')

    add_object_action(:test, "test")
  end

  def test(command, this_player)
    this_player.catch_msg("test")
  end
end
