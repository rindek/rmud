# frozen_string_literal: true
module Entities
  class RoomExit < Abstract
    attribute :to, Types::BSON
    attribute :name, Types::String
  end
end
