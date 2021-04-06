# frozen_string_literal: true
module Entities
  class RoomExit < Abstract
    attribute :to, Types::Coercible::String
    attribute :name, Types::String
  end
end
