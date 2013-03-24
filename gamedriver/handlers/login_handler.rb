require_relative "handler"

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
      player = Models::Player.find_by(:name => data.to_s)
      if player.nil?
        oo("Postac o takim imieniu nie istnieje. Sprobuj ponownie.")
      else
        @player_connection.input_handler = LoginPlayerHandler.new(@player_connection)
        @player_connection.input_handler.init(player)
      end
    end
  end
  
  def zakoncz(args)
    oo("Do zobaczenia!")
    @player_connection.disconnect
  end
end
