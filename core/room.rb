require 'singleton'
require './core/container'
require './core/modules/command'

module Core
  class Room < Container
    include Singleton
    include Modules::Command

    attr_accessor :short, :long

    def initialize
      super()

      @exits = []
      @short = "Pokoj"
      @long = "To jest przykladowy pokoj.\n"

      init_module_command
    end

    def add_exit(direction, room)
      @exits << {:direction => direction, :room => room}

      ## add_exit dodaje możliwość wywołania komendy 'go'
      ## w konkretnym kierunku, jeżeli nasz direction jest niestandardowy
      exits_obj = Cmd::Live::Exits.instance
      add_object_action(exits_obj.method(:go), direction)
    end

    def get_exits
      @exits
    end

    def get_exit(direction)
      exit = @exits.select {|e| e[:direction] == direction}.first
      if exit
        begin
          exit[:room].instance
        rescue LoadError => e
          message = "#=================================\n"
          message += "# Error: #{$!}\n"
          message += "#=================================\n"
          e.backtrace.each do |msg|
            message += "# " + msg + "\n"
          end
          message += "#=================================\n"

          puts message # na serwer
          this_player.catch_msg(message) # na ekran
          nil
        end
      else
        nil
      end
    end

    def exits
      @exits.collect {|exit| exit[:direction]}.join(", ")
    end
  end
end