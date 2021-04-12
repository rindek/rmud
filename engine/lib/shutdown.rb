# frozen_string_literal: true
module Engine
  module Lib
    class Shutdown < Abstract
      option :player, type: Types::Game::Player

      def before
        player.remove_self_from_inventory
      end

      def after
        PLAYERS.delete(player.name)
      end

      def call
        before
        player.client.close
        after

        Success()
      end
    end
  end
end
