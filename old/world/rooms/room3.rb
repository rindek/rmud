class current_namespace::Room3 < Std::Room
  def initialize
    super()

    @short = "przykladowy pokoj 3"

    add_exit('zachod', current_namespace::Room2)
  end
end
