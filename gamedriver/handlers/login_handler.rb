require_relative "handler"

class LoginHandler < Handler
  def prompt
    "Podaj swoje imie: "
  end

  def input(data)
    handle_command_or(data) do
      player = Models::Player.find_by(name: data)
      if player.nil?
        oo("Postac o takim imieniu nie istnieje. Sprobuj ponownie.")
      else
        change_handler LoginPlayerHandler do |handler|
          handler.init player
        end
      end
    end
  end
  
  def __zakoncz(args = nil)
    oo "Do zobaczenia!"
    @player_connection.disconnect
  end
end
