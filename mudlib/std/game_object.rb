## this is the base class for all in-game objects
class GameObject
  include Modules::Command
  include Modules::Declension
  include Modules::Props

  def self.count
    ObjectSpace.each_object(self).count
  end

  def initialize(*args)
    set_declension "obiekt"

    init_module_command
  end

  def short(przypadek = :mianownik)
    declension(przypadek)
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
