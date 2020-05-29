# frozen_string_literal: true
module Engine
  module Actions
    class Move < Abstract
      option :object, type: Types::MovableObject
      option :dest, type: Types::GameObject

      def call
        yield validate_dest(dest: dest)

        yield check_if_can_move

        ## remove object from previous inventory
        object.environment.inventory.remove(object) if object.environment.present?
        ## nullify environment of object
        object.environment = nil

        ## add object to new inventory
        dest.inventory.add(object)
        ## set object's new environment
        object.environment = dest

        ## validate is everything is fine
        yield validate_after_move(object: object, dest: dest)

        Success(object)
      end

      private

      def validate_dest(dest:)
        return Failure(:has_no_inventory) unless dest.respond_to?(:inventory)

        Success()
      end

      def check_if_can_move
        Success()
      end

      def validate_after_move(object:, dest:)
        return Failure(:wrong_object_environment) unless object.environment == dest
        return Failure(:missing_object_in_inventory) unless dest.inventory.has?(object)

        return Success()
      end
    end
  end
end
