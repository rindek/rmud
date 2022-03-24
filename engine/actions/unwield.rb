# frozen_string_literal: true
module Engine
  module Actions
    class Unwield < Abstract
      Schema =
        Dry::Schema.Params do
          required(:weapon).filled(Types.Instance(Entities::Game::Weapon))
          required(:player).filled(Types::Game::Player)
        end

      def execute(weapon:, player:)
        slots_weapon_is_occupying = player.slots.select { |key, v| v.none? ? false : v.bind { _1 == weapon } }.keys

        slots_weapon_is_occupying.each { |slot| player.slots[slot] = None() }

        Success()
      end

      private
    end
  end
end
