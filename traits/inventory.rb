# frozen_string_literal: true
module Traits
  module Inventory
    attr_accessor :objects

    def insert(obj)
      objects << obj
    end

    def remove(obj)
      objects.delete(obj)
    end
  end
end
