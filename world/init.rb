module World
  class Wrapper
    def self.before_shutdown
      World::Room.instance.omglolrun!
    end
  end
end