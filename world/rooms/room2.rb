class current_namespace::Room2 < Std::Room
  def initialize
    super()

    @short = "przykladowy pokoj 2"

    add_exit('poludnie', current_namespace::Room)
    add_exit('wschod', current_namespace::Room3)
    add_exit('wioska', current_namespace::Wioska2)
  end
end
