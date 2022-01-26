# frozen_string_literal: true
module Engine
  module Actions
    class Wield < Abstract
      Schema =
        Dry::Schema.Params do
          required(:weapon).filled(Types.Instance(Entities::Game::Weapon))
          required(:player).filled(Types::Game::Player)
        end

      def execute(weapon:, player:)
        yield check_already_wielding(weapon, player)
        yield check_can_wield(weapon, player)

        required_slots = find_required_slots(weapon, player)

        required_slots.each { |slot| player.slots[slot] = Some(weapon) }

        Success()
      end

      private

      def check_already_wielding(weapon, player)
        %i[left_hand right_hand].each do |hand|
          player.slots[hand].bind { |wielding| return Failure(:already_wielding) if wielding == weapon }
        end

        Success()
      end

      def check_can_wield(weapon, player)
        if twohand?(weapon)
          both_hands_empty?(player) ? Success() : Failure(:need_both_hands_empty)
        else
          either_hand_empty?(player) ? Success() : Failure(:need_one_hand_empty)
        end
      end

      def twohand?(weapon)
        weapon.hand == Constants::Game::Weapon::Hand::BOTH
      end

      def onehand?(weapon)
        weapon.hand == Constants::Game::Weapon::Hand::SINGLE
      end

      def both_hands_empty?(player)
        player.slots[:left_hand].none? && player.slots[:right_hand].none?
      end

      def either_hand_empty?(player)
        player.slots[:left_hand].none? || player.slots[:right_hand].none?
      end

      def find_required_slots(weapon, player)
        return :left_hand, :right_hand if twohand?(weapon)
        return [:right_hand] if player.slots[:right_hand].none?
        return [:left_hand] if player.slots[:left_hand].none?
      end
    end
  end
end
