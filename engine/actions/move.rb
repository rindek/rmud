# frozen_string_literal: true
module Engine
  module Actions
    class Move < Abstract
      option :object, type: Types::MovableObject
      option :dest, type: Types.Interface(:inventory)

      def call
        yield check_if_can_move

        ## remove object from previous inventory
        yield object.remove_self_from_inventory

        ## add object to new inventory
        dest.inventory.add(object)

        ## set object's new environment
        yield object.update_current_environment(dest)

        ## validate if everything is fine
        yield validate_after_move(object: object, dest: dest)

        Success(object)
      end

      private

      def check_if_can_move
        Success(true)
      end

      def validate_after_move(object:, dest:)
        return Failure(:wrong_object_environment) unless object.current_environment == dest
        return Failure(:missing_object_in_inventory) unless dest.inventory.has?(object)

        Success(true)
      end
    end
  end
end
