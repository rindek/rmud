# coding: utf-8

require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Exits
      include Singleton
      include Modules::Command

      def go(command, this_player)
        direction = command.cmd

        if !this_player.environment.is_a?(Std::Room)
          this_player.fail_message = "Nie znajdujesz sie w pokoju, wiec nie mozesz sie poruszac."
          return false
        end

        exit = this_player.environment.get_exit(direction)
        if exit.nil?
          this_player.fail_message = "Nie ma tu wyjscia prowadzego na #{direction}."
          return false
        else
          players = this_player.environment.filter(Std::Player, [this_player])
          players.each do |p|
            p.catch_msg(this_player.short + " podaza na " + direction +".\n")
          end

          this_player.move(exit)

          players = this_player.environment.filter(Std::Player, [this_player]).each do |p|
            p.catch_msg(this_player.short + " przybywa.\n")
          end

          this_player.command("spojrz")
          return true ## komenda zakończona sukcesem
        end
      end
      
      def try_go_short(command, this_player)
        dir = Modules::Direction.new(command.cmd)
        cmd = dir.long.to_c
        try_go(cmd, this_player)
      end
      
      def try_go(command, this_player)
        return go(command, this_player)
      end

      def init
        init_module_command

        directions_short  = Modules::Direction::DIRECTIONS_SHORT
        directions_long   = Modules::Direction::DIRECTIONS_LONG
        
        directions_short.each do |dir|
          add_object_action(:try_go_short, dir)
        end
        
        directions_long.each do |dir|
          add_object_action(:try_go, dir.depolonize)
        end
        
      end
    end
  end
end
