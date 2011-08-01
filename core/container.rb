require './core/base_object'

class Container < GameObject
  include Declension
  # standard konteneru. każdy obiekt, który ma mieć możliwość posiadania
  # obiektów powinien po nim dziedziczyć
  # Room, Living, cokolwiek

  # container posiada wiele obiektów oraz posiada tylko jedno 'otoczenie'
  # przykład:
  # Swiat:
  #		Room1:
  #			Skrzynia:
  #				Miecz, Topor, Nóż
  #			Skrzynia2:
  #				Sakiewka:
  #					Pieniadze
  #		Room2:
  #			Gracz1:
  #				Elementarz,
  #				Plecak:
  #					Miecz, Tarcza
  #			Gracz2:
  #				Pieniadze

  # czyli mozna to dowolnie zagniezdzac.
  # struktura jest drzewiasta

  def initialize
    super()

    @inventory = []

    set_declination("pojemnik", "pojemnika", "pojemnikowi", "pojemnik", "pojemnikiem", "pojemniku")

#    Event.instance.register('before_enter')
#    Event.register(self, 'obj_enter') do |obj, to|
#      to.enter(obj)
#    end
#    Event.instance.register('after_enter')

#    Event.instance.register('before_leave')
#    Event.register(self, 'obj_leave') do |obj, from|
#      unless from.nil?
#        from.leave(obj)
#      end
#    end
#    Event.instance.register('after_leave')

    Event.hook(self, 'object_leaving_container') do |obj, from, to|
      unless from.nil?
        unless obj.is_a?(Core::Room)
          from.leave(obj)
        end
      end
    end

    Event.hook(self, 'object_entering_container') do |obj, from, to|
      unless to.nil?
        unless obj.is_a?(Core::Room)
          to.enter(obj)
        end
      end
    end
  end

  def inventory
    @inventory
  end


  def filter(klass, out = nil)
    inv = @inventory.select {|i| i.is_a?(klass)}
    if out
      out.each do |element|
        inv.delete(element)
      end
    end

    inv
  end

  def enter(obj)
    @inventory << obj
  end

  def leave(obj)
    @inventory.delete(obj)
  end
end

