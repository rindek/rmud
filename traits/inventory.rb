# frozen_string_literal: true
module Traits
  module Inventory
    def inventory
      @inventory ||= ::Engine::Lib::Inventory.new(source: self)
    end

    def spawn(*objs)
      Array(objs).each { |obj| Engine::Actions::Move.call(object: obj, dest: self) }
    end
  end
end
