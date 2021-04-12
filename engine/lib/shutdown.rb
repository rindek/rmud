# frozen_string_literal: true
module Engine
  module Lib
    class Shutdown < Abstract
      def before(player:)
        player.remove_self_from_inventory
      end

      def after(player:)
        App[:players].delete(player.name)
      end

      def call(player:)
        yield Types::Game::Player.try(player)

        before(player: player)
        player.client.close
        after(player: player)

        Success()
      end
    end
  end
end
