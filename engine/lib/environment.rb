# frozen_string_literal: true
module Engine
  module Lib
    class Environment < Abstract
      option :source, type: Types::MovableObject
      option :environment, default: -> { Types::VOID }

      delegate :inventory, to: :environment

      def remove_from_inventory
        return Success(:in_void) if environment == Types::VOID
        yield environment.inventory.remove(source)
        @environment = Types::VOID
      end

      def update(env)
        yield validate_environment(env)
        Success(@environment = env)
      end

      private

      def validate_environment(env)
        Try[Dry::Types::ConstraintError] { Types.Interface(:inventory)[env] }
      end
    end
  end
end
