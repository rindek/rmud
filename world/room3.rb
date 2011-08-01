require './core/room.rb'

module World
  class Room3 < Core::Room
    def initialize
      super()

      @short = "przykladowy pokoj 3"

      add_exit('zachod', World::Room2)
    end
  end
end