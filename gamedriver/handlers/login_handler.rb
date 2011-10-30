class LoginHandler < Handler
  @@commands = [:zakoncz]
  
  def prompt
    "Podaj swoje imie: "
  end
  
  def input(data)
    data = data.to_c
    if @@commands.include?(data.to_sym)
      send(data.to_sym, data.args)
    else
      if data.to_s == 'nowe' && data.args[0] == 'konto'
        @player_connection.input_handler = NewAccountHandler.new(@player_connection)
        @player_connection.input_handler.init
      elsif data.to_s == 'konto' && data.has_args?
        account = Models::Account.first(:name => data.args[0])
        if account.nil?
          oo("Takie konto nie istnieje. Sprobuj ponownie.")
        else
          @player_connection.input_handler = LoginAccountHandler.new(@player_connection)
          @player_connection.input_handler.init(account)
        end
      else
        @model_player = Models::Player.new
        player = @model_player.get_by_name(data.to_s)
        if player.nil?
          oo("Postac o takim imieniu nie istnieje. Sprobuj ponownie.")
        else
          @player_connection.input_handler = LoginPlayerHandler.new(@player_connection)
          @player_connection.input_handler.init(player)
        end
      end
    end
  end
  
  def zakoncz(args)
    oo("Do zobaczenia!")
    @player_connection.disconnect
  end
end
