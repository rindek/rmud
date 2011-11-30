# coding: utf-8
class Karczma < Std::Room
  include Singleton

  def initialize
    super()

    @short = "Karczma"

    @long = "Karczma. O.\n"    

    add_exit('wyjscie', Wioska2)

  end

end