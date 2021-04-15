# frozen_string_literal: true
module Entities
  module Game
    class Item < MovableObject
      attribute :id, Types::String
      attribute :adjectives, Types::Array.of(Types::String)
      attribute :name, Types::String

      def present
        [adjectives, name].flatten.join(" ")
      end
    end
  end
end
