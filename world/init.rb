module World
  class Wrapper
    include Singleton
    
    def self.before_shutdown
      ## do things within game to stop game
      World::Room.instance.omglolrun!
    end
  end
end