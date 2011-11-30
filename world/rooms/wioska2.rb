class Wioska2 < Std::Room
  def initialize
    super()

    @short = "przykladowa wioska"

    add_exit('zachod', World::Rooms::Room2)
  end
end
