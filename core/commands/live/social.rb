# coding: utf-8

require 'singleton'
require './core/modules/command'

module Cmd
  module Live
    class Social
      include Singleton
      include Modules::Command

      def say(command, tp)
        message = command.args.join(" ")

        tp.catch_msg("Mowisz: #{message}\n")
        tp.environment.filter(Std::Player, [tp]).each do |p|
          p.catch_msg("#{tp.short.capitalize} mowi: #{message}\n")
        end
      end

      def init
        init_module_command

        add_object_action(:say, "powiedz")
      end
    end
  end
end
