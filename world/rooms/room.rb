# coding: utf-8

# GameObject("room", Std::Room) do
#   def initialize
#     puts 'hi'
#   end
# end

Room {
  short "przykladowy pokoj 1"
  exits N => "room.1",
        S => "room.2"

  events_time 10
  events "Wiatr delikatnie kolysze drzewa.\n",
         "Masz wrazenie, ze ktos za toba stoi.\n",
         "Usmiechasz sie mimowolnie, bo to dziala :-)\n"

  command "test" do |tp|
    tp.msg("hi")
  end
}

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
