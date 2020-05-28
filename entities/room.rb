# frozen_string_literal: true

module Entities
  class Room < Dry::Struct
    attribute :short, Types::String
    attribute :long, Types::String
    attribute :exits, Types::Array.of(Types.Instance(Entities::RoomExit))

    def inventory
      @inventory ||= Entities::Inventory.new(environment: self)
    end
  end
end
