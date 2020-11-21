# frozen_string_literal: true
module Entities
  class Player < Creature
    option :model, type: Types.Instance(Models::Player)

    include Traits::Inventory
  end
end
