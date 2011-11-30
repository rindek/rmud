class Room3 < Std::Room
  def initialize
    super()

    @short = "przykladowy pokoj 3"

    add_exit('zachod', World::Rooms::Room2)
  end
end
