# frozen_string_literal: true
module Entities
  class Reference < Abstract
    attribute :type, Types::String.enum("player", "item")
    attribute :id, Types::Coercible::String

    def origin
      case type
      when "player"
        State::Player.get(id)
      when "item"
        Some(:item)
      end
    end
  end
end
