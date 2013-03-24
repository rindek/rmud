class GameHandler < Handler
  def init(player)
    @player = player
  end


  def input(data)
    command = data.to_c

    @player.fail_message = "Slucham?"

    if command.cmd[0] == "'"
      command = ("powiedz #{data[1..data.length]}").to_c
    end

    ## najpierw obiekty, które mam przy sobie
    inv = @player.inventory

    inv.each do |obj|
      if obj.respond_to_command?(command)
        func = obj.get_command(command)
        return if func.call(command, @player) != false
      end
    end

    ## obiekty mojego otoczenia
    inv = @player.environment.inventory
    inv.each do |obj|
      if obj.respond_to_command?(command)
        func = obj.get_command(command)
        return if func.call(command, @player) != false
      end
    end

    ## obiekty lokacji
    room = @player.environment
    if room.respond_to_command?(command)
      func = room.get_command(command)
      return if func.call(command, @player) != false
    end

    ## na końcu szukamy po obiektach soula

    souls = @player.get_souls
    souls.each do |soul|
      if soul.respond_to_command?(command)
        func = soul.get_command(command)
        return if func.call(command, @player) != false
      end
    end

    ## jeżeli dotarliśmy do tego miejsca oznacza to, że wszystkie
    ## poprzednie komendy zakończyly się failem, wyświetlamy fail message
    oo(@player.fail_message)
  end
end
