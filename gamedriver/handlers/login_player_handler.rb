require_relative "handler"

class LoginPlayerHandler < Handler
  attr_accessor :db_player, :state

  def init(model: model)
    self.db_player = model
    self.state = :password_input
  end
  
  def prompt
    case self.state
    when :password_input then
      echo_off
      "Podaj haslo: "
    when :password_input_2nd_try then
      echo_off
      "Podaj haslo: "
    else
      "Powazny blad... ?"
    end
  end
  
  def input(data)
    echo_on
    send(self.state, data.to_c)
  end

  def password_input(data)
    if Digest::SHA1.hexdigest(data.cmd) != self.db_player.password
      oo("Haslo jest niepoprawne, sprobuj wpisac ponownie.")
      self.state = :password_input_2nd_try
    else
      login_success
    end
  end

  def password_input_2nd_try(data)
    if Digest::SHA1.hexdigest(data.cmd) != self.db_player.password
      oo("Haslo jest niepoprawne, do zobaczenia!")
      self.player.disconnect
    else
      login_success
    end
  end

  def login_success
    game_player = Std::Player.new(self.player, self.db_player.id)
    room   = World::Rooms::Room.instance
    game_player.move(room)

    change_handler GameHandler do |handler|
      handler.init game_player: game_player
    end
    
    game_player.command("system")
    game_player.command("spojrz")
  end
end

