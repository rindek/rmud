class current_namespace::Wioska2 < Std::Room
  def initialize
    super()

    @short = "przykladowa wioska"

    add_exit('zachod', current_namespace::Room2)
  end
end
