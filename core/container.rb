require 'core/base_object'

class Container < BaseObject
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

  def enter(obj, from)
    @inventory << obj
  end

  def leave(obj, to)
    @inventory.delete(obj)
  end
end

