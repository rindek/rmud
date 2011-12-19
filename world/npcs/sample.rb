class current_namespace::Sample < Std::Living
  def initialize(*args)
    super(*args)

    set_declension "marek"
    set_random_move(10)
  end
end
