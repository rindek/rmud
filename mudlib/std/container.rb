require "./mudlib/std/game_object"

module Std
  class Container < GameObject
    include GameModules::HasInventory

    def initialize(*args)
      super(*args)

      init_has_inventory_module
    end
  end
end
