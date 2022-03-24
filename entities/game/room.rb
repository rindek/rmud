# frozen_string_literal: true
module Entities
  module Game
    class Room < ImmovableObject
      attribute :id, Types::String
      attribute :short, Types::String
      attribute :long, Types::String
      attribute :exits, Types::Array.of(Types.Entity(Entities::Game::RoomExit))
      attribute? :callbacks, Types::Hash.map(Types::Symbol, Types::Proc).default { {} }

      include Traits::Inventory

      def dump_info
        attributes.slice(:id, :short).merge(class: self.class)
      end
    end
  end
end
