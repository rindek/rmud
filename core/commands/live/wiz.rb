require 'singleton'
require 'core/modules/command'

module Cmd
  module Live
    class Wiz
      include Singleton
      include Modules::Command


      ## NIE DZIAŁA - SYPIE BŁĘDAMI GDY CHCE COŚ ZAŁADOWAĆ Z POZIOMU
      ## KLIENTA - DZIWNA SPRAWA
#      def load(command)
##        debugger
#        __load(command.cmd)
#        return true
#      end


      def init
        init_module_command

#        add_object_action(:load, "load")
      end
    end
  end
end
