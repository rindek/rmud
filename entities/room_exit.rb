# frozen_string_literal: true
module Entities
  class RoomExit < Dry::Struct
    attribute :id, Types::String
    attribute :name, Types::String
  end
end
