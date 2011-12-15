require "./mudlib/std/living"

module Std
  class Player < Std::Living
    attr_accessor :fail_message, :id

    def initialize(connection, id)
      super(connection, id)

      @connection = connection
      @id = id

      @souls = []

      @souls << Cmd::Live::Standard.instance
      @souls << Cmd::Live::Exits.instance
      @souls << Cmd::Live::Items.instance
      @souls << Cmd::Live::Social.instance

      @souls << Cmd::Live::Wiz.instance

      ## aby zainicjalizować komendy
      update_hooks

      ## 
      @fail_message = "Slucham?"

      set_declension Models::Player.get(@id).declension
    end

    def update_hooks
      @souls.each {|soul| soul.init }
    end

    def get_souls
      @souls
    end

    def is_player?
      true
    end

    def catch_msg(msg)
      @connection.print(msg)
    end

    def disconnect
      @connection.disconnect
      free
    end

    def command(str)
      @connection.input_handler.input(str)
    end
  end
end