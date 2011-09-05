# coding: utf-8

require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Exits
      include Singleton
      include Modules::Command

      def go(command)
        direction = command.cmd

        if !this_player.environment.is_a?(Core::Room)
          fail_message("Nie znajdujesz sie w pokoju, wiec nie mozesz sie poruszac.")
          return false
        end

        exit = this_player.environment.get_exit(direction)
        if exit.nil?
          fail_message("Nie ma tu wyjscia prowadzego na #{direction}.\n")
          return false
        else
          players = this_player.environment.filter(Player)
          players.delete(this_player)
          players.each do |p|
            p.catch_msg(this_player.short + " podaza na " + direction +".\n")
          end

          this_player.move(exit)

          players = this_player.environment.filter(Player, [this_player]).each do |p|
            p.catch_msg(this_player.short + " przybywa.\n")
          end

          this_player.command("spojrz")
          return true ## komenda zakończona sukcesem
        end
      end
      
      def try_go_short(command)
        dir = Modules::Direction.new(command.cmd)
        cmd = Command.new(dir.long)
        try_go(cmd)
      end
      
      def try_go(command)
        return go(command)
      end

      def init
        init_module_command

        directions_short = ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw', 'u', 'd'] 
        directions_long = [
          'północ', 'północny-wschód', 'wschód', 
          'południowy-wschód', 'południe', 'południowy-zachód', 'zachód', 
          'północny-zachód', 'góra', 'dół'
        ]
        
        directions_short.each do |dir|
          add_object_action(:try_go_short, dir)
        end
        
        directions_long.each do |dir|
          add_object_action(:try_go, dir)
          add_object_action(:try_go, dir.depolonize)
        end
        
      end
    end
  end
end
