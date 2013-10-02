require_relative "handler"

class GameHandler < Handler
  attr_accessor :game_player

  def init(game_player: game_player)
    self.game_player = game_player
  end


  def input(data)
    command = data.to_c

    self.game_player.fail_message = "Slucham?"

    if command.cmd[0] == "'"
      command = ("powiedz #{data[1..data.length]}").to_c
    end

    ## najpierw obiekty, które mam przy sobie
    inv = self.game_player.inventory

    inv.each do |obj|
      if obj.respond_to_command?(command)
        func = obj.get_command(command)
        return if func.call(command, self.game_player) != false
      end
    end

    ## obiekty mojego otoczenia
    inv = self.game_player.environment.inventory
    inv.each do |obj|
      if obj.respond_to_command?(command)
        func = obj.get_command(command)
        return if func.call(command, self.game_player) != false
      end
    end

    ## obiekty lokacji
    room = self.game_player.environment
    if room.respond_to_command?(command)
      func = room.get_command(command)
      return if func.call(command, self.game_player) != false
    end

    ## na końcu szukamy po obiektach soula

    souls = self.game_player.get_souls
    souls.each do |soul|
      if soul.respond_to_command?(command)
        func = soul.get_command(command)
        return if func.call(command, self.game_player) != false
      end
    end

    ## jeżeli dotarliśmy do tego miejsca oznacza to, że wszystkie
    ## poprzednie komendy zakończyly się failem, wyświetlamy fail message
    oo(self.game_player.fail_message)
  end
end
