## this is the base class for all in-game objects
class GameObject
  include Modules::Command

  def self.count
    ObjectSpace.each_object(self).count
  end

  def initialize(*args)

    init_module_command
  end

  def short
    "game_object"
  end

  def environment
    @environment
  end

  def environment=(obj)
    @environment = obj
  end

  def move(dest)
    unless environment.nil?
      environment.remove(self)
    end
    self.environment = dest
    environment.add(self)
  end

  def __destruct__
    if environment
      environment.remove(self)
    end
    :freed
  end
end
