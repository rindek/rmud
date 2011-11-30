require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Items
      include Singleton
      include Modules::Command

#      def glance(command)
#        this_player.catch_msg(this_player.environment.long)
#        this_player.environment.filter(GameObject, [this_player]).each do |obj|
#          this_player.catch_msg(obj.short + ", ")
#        end
#        this_player.catch_msg("\n")
#        if (this_player.environment.is_a?(Core::Room))
#          this_player.catch_msg("Exits: " + this_player.environment.exits + "\n")
#        end
#
#        return true
#      end
#
#      def logout(command)
#        this_player.catch_msg("Do zobaczenia!\n")
#        this_player.disconnect
#      end
#
#      def init
#        init_module_command
#
#        add_object_action(:glance, "spojrz")
#        add_object_action(:glance, "sp")
#
#        add_object_action(:logout, "zakoncz")
#      end

      def inventory(command, this_player)
        this_player.inventory.each do |obj|
          this_player.catch_msg(obj.short + ", ")
        end
        this_player.catch_msg("\n")
      end

      def pilka(command, tp) 
        pilka = World::Objects::Pilka.new
        pilka.move(tp)
        tp.catch_msg("Masz pilke.\n")
      end

      def init
        init_module_command

        add_object_action(:inventory, "i")
        add_object_action(:inventory, "inwentarz")
        add_object_action(:inventory, "ekwipunek")

        add_object_action(:pilka, "pilka")
      end
    end
  end
end
