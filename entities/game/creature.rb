# frozen_string_literal: true
module Entities
  module Game
    class Creature < MovableObject
      attribute :id, Types::String
      attribute :adjectives, Types::Array.of(Types::String)
      attribute :name, Types::String
      attribute :events, Types::Array.of(Types::String)
      attribute? :callbacks, Types::Hash.map(Types::Symbol, Types::Proc).default { {} }

      def decorator(observer:)
        [adjectives, name].flatten.join(" ")
      end

      def initialize(...)
        start_events_timer
        super(...)
      end

      include Traits::Emote
      include Traits::Inventory
    end
  end
end
