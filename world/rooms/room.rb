# coding: utf-8
class current_namespace::Room < Std::Room

  def initialize
    super()

    @short = "przykladowy pokoj 1"

    add_exit('polnoc', current_namespace::Room2)
    add_exit('niestandardowe', "/world/rooms/room2")
    add_exit('dimm', '/world/averland/dimm/lokacje/wioska1')

    set_event_time(10.0)
    add_event("Wiatr delikatnie kolysze drzewa.\n")
    add_event("Masz wrazenie, ze ktos za toba stoi.\n")
    add_event("Usmiechasz sie mimowolnie, bo to dziala :-)\n")

    add_object_action(:test, "test")
  end

  def test(command, this_player)
    this_player.catch_msg("test")
  end
end
