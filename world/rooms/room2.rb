class Room2 < Std::Room
  def initialize
    super()

    @short = "przykladowy pokoj 2"

    add_exit('poludnie', World::Rooms::Room)
    add_exit('wschod', World::Rooms::Room3)
    add_exit('wioska', Rooms::Wioska2)
  end
end
