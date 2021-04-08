# frozen_string_literal: true
module Engine
  module Lib
    class Environment < Abstract
      option :source, type: Types::Game::MovableObject
      option :dest, default: -> { Types::Game::VOID }

      delegate :inventory, to: :dest

      def remove_self_from_inventory
        return Success(:in_void) if dest == Types::Game::VOID
        yield inventory.remove(source)
        Success(@dest = Types::Game::VOID)
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
