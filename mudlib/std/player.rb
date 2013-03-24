require "./mudlib/std/living"

module Std
  class Player < Std::Living
    attr_accessor :fail_message, :id

    def initialize(connection, id)
      super(connection, id)

      @connection = connection
      @id = id

      @souls << Cmd::Live::Wiz.instance
      ## aby zainicjalizować komendy
      update_hooks

      ## 
      @fail_message = "Slucham?"

      set_declension Models::Player.find(@id).entry
    end

    def is_player?
      true
    end

    def catch_msg(msg, newline = false)
      if newline
        msg = "#{msg}\n"
      end

      @connection.print(msg)
    end

    def disconnect
      @connection.disconnect
    end

    def command(str)
      @connection.input_handler.input(str)
    end
  end
end
