# coding: utf-8
class AccountManagementPlayerCreationHandler < Handler
  def init(account)
    @account = account

    @state = :name
    @player = Models::Player.new(:account => @account, :created => false)

    @declension = {:mianownik => nil, :dopelniacz => nil, :celownik => nil, 
      :biernik => nil, :narzednik => nil, :miejscownik => nil}

    @declension.keys.each_index do |i|
      selfclass.send(:define_method, @declension.keys[i]) do |data|
        @declension[@declension.keys[i]] = data.cmd
        unless @declension.keys[i.succ].nil?
          @state = @declension.keys[i.succ]
        else
          oo("Oto podana przez ciebie odmiana: ")
          @declension.each do |k, v|
            oo("#{k.to_s.capitalize}: #{v}")
          end
          oo("Jezeli wszystko sie zgadza, wpisz 'tak', jezeli chcesz ja poprawic, wpisz 'popraw'")
          @state = :confirmation
        end
      end
    end
  end

  def prompt
    case @state
    when :name
      "Podaj imie dla twojej postaci: "
    when :dopelniacz
      "Dopelniacz (kogo/czego nie ma?): "
    when :celownik
      "Celownik (komu/czemu sie przygladam/przedstawiam?): "
    when :biernik
      "Biernik (kogo/co widze?): "
    when :narzednik
      "Narzednik (z kim/czym jestem?): "
    when :miejscownik
      "Miejscownik (o kim/czym rozmawiam?): "
    when :confirmation
      "Twoj wybor: 'tak' / 'popraw': "
    else 
      "Wystapil blad..."
    end
  end

  def input(data)
    send(@state, data.to_c)
  end

  def name(data)
    oo
    if data.cmd.size < 3
      oo("Imie postaci musi miec przynajmniej 3 litery.")
    elsif Models::Player.first(:name => data.cmd)
      oo("Postac o takim imieniu juz istnieje, sprobuj ponownie.")
    else
      @player.name = data.cmd
      if @player.save
        oo("Tworzymy postac o imieniu: '#{@player.name.capitalize}'")
        @declension[:mianownik] = @player.name.downcase
        @state = :dopelniacz
      else
        oo("Wystapil blad w tworzeniu postaci, sprobuj ponownie.")
      end
    end
  end

  def confirmation(data)
    oo
    if data.cmd != "tak" && data.cmd != "popraw"
      oo("Niepoprawny wybor.")
    else
      if data.cmd == 'tak'
        @dec = Models::Declension.new(@declension)
        @dec.nazwa = "player_#{@declension[:mianownik]}"
        if @dec.save 
          @player.declension_nazwa = @dec.nazwa
          if @player.save
            oo("Postac zostala poprawnie utworzona. Mozesz sie juz na nia zalogowac.")
            @player_connection.input_handler = AnyKeyNextHandler.new(@player_connection, LoginHandler)
          else
            oo("Wystapil blad przy tworzeniu postaci (zapis odmiany)")
          end
        else
          oo("Wystapil blad przy probie zapisu odmiany")
        end
      elsif data.cmd == 'popraw'
        @state = :dopelniacz
      end
    end
  end

  # def prompt
  #   case @state
  #   when :new_player_password then
  #     echo_off
  #     "Podaj haslo ktorym chcesz sie logowac na postac: "
  #   when :change_player_password then
  #     echo_off
  #     "Podaj aktualne haslo na postac: "
  #   when :password_confirm then
  #     echo_off
  #     "Potwierdz haslo: "
  #   else
  #     "Blad..."
  #   end
  # end

  # def input(data)
  #   echo_on
  #   send(@state, data.to_c)
  # end

  # def change_player_password(data)
  #   oo
  #   if Digest::SHA1.hexdigest(data.cmd) != @account.player_password
  #     oo("Aktualne haslo sie nie zgadza, sprobuj ponownie.")
  #   else
  #     @state = :new_player_password
  #   end
  # end
  
  # def new_player_password(data)
  #   oo
  #   if data.cmd.size < 5
  #     oo("Haslo musi miec conajmniej 5 liter")
  #   else
  #     @password = Digest::SHA1.hexdigest(data.cmd)
  #     @state = :password_confirm
  #   end
  # end
  
  # def password_confirm(data)
  #   oo
  #   if Digest::SHA1.hexdigest(data.cmd) != @password
  #     oo("Podane hasla sie nie zgadzaja... nastapi powrot do menu")
  #   else
  #     @account.player_password = @password
  #     @account.save
  #     oo("Haslo zostalo poprawnie zmienione.")
  #   end
  #   @player_connection.input_handler = AnyKeyNextHandler.new(@player_connection, @menu_handler)
  # end
end