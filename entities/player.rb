# frozen_string_literal: true
module Entities
  class Player < Creature
    attribute :id, Types::BSON
    attribute :name, Types::String
    attribute :password, Types::String

    include Traits::Inventory
  end
end
