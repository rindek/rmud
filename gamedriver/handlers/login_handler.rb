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
      end
    end
  end
  
  def zakoncz(args)
    oo("Do zobaczenia!")
    @player_connection.disconnect
  end
end
