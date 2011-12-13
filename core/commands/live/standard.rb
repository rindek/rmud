# coding: utf-8

require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Standard
      include Singleton
      include Modules::Command

      def glance(command, this_player)
        this_player.catch_msg("#{this_player.environment.class.to_s} (#{game_path(this_player.environment.class.to_s)})\n")
        this_player.catch_msg(this_player.environment.long)
        this_player.environment.filter(GameObject, [this_player]).each do |obj|
          this_player.catch_msg(obj.short + ", ")
        end
        this_player.catch_msg("\n")
        if (this_player.environment.is_a?(Std::Room))
          this_player.catch_msg(this_player.environment.exits_description + "\n")
        end

        return true
      end

      def logout(command, this_player)
        this_player.catch_msg("Do zobaczenia!\n")
        this_player.environment.filter(Std::Player, [this_player]).each do |p|
          p.catch_msg(this_player.short + " opuszcza ten swiat.\n")
        end
        # this_player.remove()
#        this_player.move(Void.new)
#        this_player.disconnect

        this_player.move(Std::Void.new)
        this_player.disconnect
      end

      def system(command, tp)
        tp.catch_msg("Swiat odrodzil sie\t: #{$boot_time}\n")
        tp.catch_msg("Lokalny czas\t\t: #{Time.now}\n")
        tp.catch_msg("Swiat istnieje\t\t: #{time2str(Time.now - $boot_time, :days)}\n")
        tp.catch_msg("Utworzonych obiektow\t: #{GameObject.count}\n")
        tp.catch_msg("Ilosc alarmow\t\t: #{Alarm.alarms.count}\n")
      end

      def init
        init_module_command

        add_object_action(:glance, "spojrz")
        add_object_action(:glance, "sp")

        add_object_action(:system, "system")
        add_object_action(:logout, "zakoncz")
      end
    end
  end
end
