# frozen_string_literal: true
module Entities
  module Game
    class Creature < MovableObject
      include Traits::Inventory
    end
  end
end
