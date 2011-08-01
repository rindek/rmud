require './core/room.rb'

module World
  class Room2 < Core::Room
    def initialize
      super()

      @short = "przykladowy pokoj 2"

      add_exit('poludnie', World::Room)
      add_exit('wschod', World::Room3)
    end
  end
end