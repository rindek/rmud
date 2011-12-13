# coding: utf-8
class current_namespace::Karczma < Std::Room
  include Singleton

  def initialize
    super()

    @short = "Karczma"

    @long = "Karczma. O.\n"    

    add_exit('wyjscie', current_namespace(1)::Wioska2)

  end

end