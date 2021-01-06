# frozen_string_literal: true
module Engine
  module Lib
    class Environment < Abstract
      option :source, type: Types::MovableObject
      option :dest, default: -> { Types::VOID }

      delegate :inventory, to: :dest

      def remove_self_from_inventory
        return Success(:in_void) if dest == Types::VOID
        yield inventory.remove(source)
        @dest = Types::VOID
      end

      def update(env)
        yield validate_environment(env)
        Success(@dest = env)
      end

      private

      def validate_environment(env)
        Try[Dry::Types::ConstraintError] { Types.Interface(:inventory)[env] }
      end
    end
  end
end
