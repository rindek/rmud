require './core/modules/declension'
require './core/modules/command'

class GameObject
  include Modules::Command

  attr_accessor :short

  def initialize
    @environment = nil
    @short = "obiekt"

    init_module_command
  end

  def environment
    @environment
  end

  def environment=(obj)
    @environment = obj
  end

  ## nie mam głowy do tego, musiałbym to jakoś rozpisać....
  def move(dest_obj)
#    if (dest_obj.is_a?(Container))
#      if !@environment.nil?
#        Event.fire('obj_enter', self, dest_obj)
#        @environment = dest_obj
#      end

    if (dest_obj.is_a?(Container))
      ## na @enviroment, ktory obiekt dokad
      Event.fire('object_leaving_container', @environment, self, dest_obj)
      ## na obiekcie ktory wychodzi, from, to
      Event.fire('object_leaving_container', self, @environment, dest_obj)
      ## usuwamy obiekt z aktualnego kontenera
      unless @environment.nil?
        @environment.leave(self)
      end

      ## na obiekcie ktory wchodzi, from, to
      Event.fire('object_entering_container', self, @environment, dest_obj)
      ## na obiekcie dest_obj, co, skad
      Event.fire('object_entering_container', dest_obj, self, @environment)

      ## wrzucamy obiekt do dest_obj
      dest_obj.enter(self)
      @environment = dest_obj
    end



#      Event.fire('before_move', self)
#      Event.fire('object_moving', self)
#      Event.fire('after_move', self)
#    end
  end

#  def move(dest_obj)
#    if (dest_obj.is_a?(Container))
#      # usuwamy obiekt z aktualnego kontenera
#      if !@environment.nil?
#        if dest_obj.enter(self, @environment)
#          @environment.leave(self, dest_obj)
#          @environment = dest_obj
#        end
#      else # nie mielismy environment, po prostu wrzucamy w kontener
#        dest_obj.enter(self, nil)
#        @environment = dest_obj
#      end
#    end
#  end

  # usuwamy obiekt z pamieci
  def remove()
    # jezeli istnieje obiekt w jakims kontenerze to go stamtad wyciagamy
    if !@environment.nil?
      @environment.leave(self, nil)
      @environment = nil
    end
    # garbage collector zajmie sie reszta...
  end
end
