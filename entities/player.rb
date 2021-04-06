# frozen_string_literal: true
module Entities
  class Player < Creature
    attribute :id, Types::Coercible::String
    attribute :name, Types::String
    attribute :password, Types::String
    attribute :room_id, Types::Coercible::String
    include Traits::Inventory
    def room
      Try[Dry::Container::Error] { App[:rooms].resolve(room_id) }.to_maybe
    end
  end
end
