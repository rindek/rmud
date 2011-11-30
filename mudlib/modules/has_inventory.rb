module GameModules
  module HasInventory
    def init_has_inventory_module
      @inventory = []
    end

    def inventory
      @inventory
    end

    def filter(klass, out = nil)
      inv = @inventory.select {|i| i.is_a?(klass)}
      unless out.nil?
        inv - out
      else
        inv
      end
    end

    def add(obj)
      unless @inventory.include?(obj)
        @inventory << obj
      end
    end

    def remove(obj)
      @inventory.delete(obj)
    end
  end
end