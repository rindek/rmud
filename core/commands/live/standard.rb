require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Standard
      include Singleton
      include Modules::Command

      def glance(command)
        this_player.catch_msg(this_player.environment.long)
        this_player.environment.filter(GameObject, [this_player]).each do |obj|
          this_player.catch_msg(obj.short + ", ")
        end
        this_player.catch_msg("\n")
        if (this_player.environment.is_a?(Core::Room))
          this_player.catch_msg("Exits: " + this_player.environment.exits + "\n")
        end

        return true
      end

      def logout(command)
        this_player.catch_msg("Do zobaczenia!\n")
        this_player.disconnect
      end

      def init
        init_module_command

        add_object_action(:glance, "spojrz")
        add_object_action(:glance, "sp")

        add_object_action(:logout, "zakoncz")
      end
    end
  end
end
