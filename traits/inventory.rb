# frozen_string_literal: true
module Traits
  module Inventory
    def inventory
      @inventory ||= ::Engine::Lib::Inventory.new(source: self)
    end
  end
end
