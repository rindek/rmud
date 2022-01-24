module Entities
  module Game
    class Weapon < Item
      attribute :hit_type, Types::Game::Weapon::HitType
      attribute :hand, Types::Game::Weapon::Hand
      attribute :dps, Types::Float
      attribute :level, Types::Integer.constrained(gteq: 0)
      attribute :bonus, Types::Game::Item::Bonus
      attribute :durability, Types::Integer.constrained(gteq: 0)
      attribute :weight, Types::Float.constrained(gteq: 0)
    end
  end
end
