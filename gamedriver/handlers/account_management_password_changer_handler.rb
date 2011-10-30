class AccountManagementPasswordChangerHandler < Handler
  def init(account, menu_handler)
    @account = account
    @menu_handler = menu_handler

    if @account['player_password'].nil?
      @state = :new_player_password
    else
      @state = :change_player_password
    end
  end

  def prompt
    case @state
    when :new_player_password then
      echo_off
      "Podaj haslo ktorym chcesz sie logowac na postac: "
    when :change_player_password then
      echo_off
      "Podaj aktualne haslo na postac: "
    when :password_confirm then
      echo_off
      "Potwierdz haslo: "
    else
      "Blad..."
    end
  end

  def input(data)
    echo_on
    send(@state, data.to_c)
  end

  def change_player_password(data)
    oo
    if Digest::SHA1.hexdigest(data.cmd) != @account.player_password
      oo("Aktualne haslo sie nie zgadza, sprobuj ponownie.")
    else
      @state = :new_player_password
    end
  end
  
  def new_player_password(data)
    oo
    if data.cmd.size < 5
      oo("Haslo musi miec conajmniej 5 liter")
    else
      @password = Digest::SHA1.hexdigest(data.cmd)
      @state = :password_confirm
    end
  end
  
  def password_confirm(data)
    oo
    if Digest::SHA1.hexdigest(data.cmd) != @password
      oo("Podane hasla sie nie zgadzaja... nastapi powrot do menu")
    else
      @account.player_password = @password
      @account.save
      oo("Haslo zostalo poprawnie zmienione.")
    end
    @player_connection.input_handler = AnyKeyNextHandler.new(@player_connection, @menu_handler)
  end

end