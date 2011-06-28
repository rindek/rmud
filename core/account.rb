require 'digest/sha1'

require 'core/account_player.rb'

class Account

  DIR = "/accounts/"

  attr_accessor :name
  attr_accessor :password
  attr_accessor :player_password
  attr_accessor :email
  #  attr_accessor :players

  # tworzymy nowego usera
  def create_new_user(user)
    set_environment("account creator")

    user.catch_msg("Witaj w kreatorze tworzenia nowego konta.\n")

    step_1(user) # nazwa dla konta
    step_2(user) # haslo dla konta
    step_3(user) # email dla konta

    # ustawiamy pusta tablice graczy
    # oraz puste haslo na postaci
    @player_password = nil
    @players = []

    save
    user.catch_msg("Nowe konto zostalo utworzone. Mozesz sie na nie zalogowac wpisujac 'konto #{@name}'.\n")
  end

  def step_1(user) # nazwa konta
    loop do
      command = Engine.instance.read(user, "Podaj nazwe dla swojego konta: ")
      if /^[A-Za-z]+$/.match(command.cmd)
        if command.cmd.size < 5
          user.catch_msg("Nazwa konta musi skladac sie z conajmniej 5 liter\n")
          #        elsif Engine.instance.accounts.select {|acc| acc.name == command.cmd}.first
        elsif !self.find_account_by_name(command.cmd).nil?
          user.catch_msg("Ta nazwa konta jest juz zajeta, wybierz inna.\n")
        else
          @name = command.cmd.downcase
          user.catch_msg("Twoja nazwa konta to '#{@name}'\n")
          break
        end
      else
        user.catch_msg("Nazwa konta moze skladac sie tylko z liter a-z\n")
      end
    end
  end

  def step_2(user) # haslo na konto
    loop do
      user.dont_echo
      command = Engine.instance.read(user, "Podaj haslo na konto: ")
      user.catch_msg("\n")
      if command.cmd.size < 5
        user.catch_msg("Haslo musi miec conajmniej 5 liter\n")
      else
        @password = Digest::SHA1.hexdigest(command.cmd)
        break
      end
    end
  end

  def step_3(user) # email na konto
    loop do
      command = Engine.instance.read(user, "Podaj adres email: ")
      if !email_validate(command.cmd)
        user.catch_msg("Niepoprawny format adresu email.\n")
      else
        @email = command.cmd
        break
      end
    end
  end

  def find_account_by_name(name)
    acc = Models::Account.new
    acc.get_by_name(name)
  end

  def email_validate(email)
    email.match(/^[0-9A-Za-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end

  def save
    model = Models::Account.new
    model.save(0, {:name => @name, :email => @email, :password => @password, :player_password => @player_password})
  end

  def menu
    current_user.catch_msg("[1] - lista stworzonych postaci\n")
    current_user.catch_msg("[2] - tworzenie nowej postaci\n")
    current_user.catch_msg("[3] - utworzenie/zmiana hasla postaci\n")
    #    current_user.catch_msg("[4] - zmiana hasla konta\n")
    current_user.catch_msg("[zakoncz] - zakonczenie zarzadzania kontem, powrot do ekranu logowania\n")
  end

  ## main menu
  def manage(account)
    @model_account = Models::Account.new
    loop do
      account = @model_account.by_id(account['id'])

      current_user.catch_msg("Zarzadzanie kontem\n")
      menu

      cmd = Engine.instance.read(current_user, "Wybierz opcje: ")

      method = "manage_cmd_" + cmd.cmd

      if self.respond_to?(method)
        respond = self.send(method, account)
        if respond.eql?(false)
          break
        end
      else
        current_user.catch_msg("Bledna opcja.\n")
      end
    end
  end

  ## opcja 1 - lista stworzonych postaci
  def manage_cmd_1(account)
    players = @model_account.get_players(account['id'])

    if players.size == 0
      current_user.catch_msg("Nie masz stworzonych zadnych postaci.\n")
      Engine.instance.read(current_user, "Wcisnij enter. ")
    else
      current_user.catch_msg("Oto lista twoich postaci:\n")
      players.each do |player|
        str = " * " + player['name'].capitalize

        current_user.catch_msg str + "\n"
      end
      Engine.instance.read(current_user, "Wcisnij enter. ")
    end
  end

  ## opcja 2 stworzenie nowej postaci
  def manage_cmd_2(account)
    if account['player_password'].nil?
      current_user.catch_msg("Musisz najpierw ustawic haslo na postac korzystajac z opcji '3'\n")
      return true
    end

    @player_model = Models::Player.new

    loop do
      command = Engine.instance.read(current_user, "Podaj imie dla swojej postaci: ")
      if /^[A-Za-z]+$/.match(command.cmd)
        if command.cmd.size < 3
          current_user.catch_msg("Imie postaci musi skladac sie z conajmniej 3 liter\n")
        elsif !@player_model.get_by_name(command.cmd).nil?
          current_user.catch_msg("Postac z takim imieniem juz istnieje, wybierz inne imie.\n")
        else
          create_player(command.cmd, account)
          break
        end
      else
        current_user.catch_msg("Imie postaci moze skladac sie tylko z liter a-z\n")
      end
    end
  end

  ## opcja 3 - ustawienie/zmiana hasła postaci
  def manage_cmd_3(account)
    loop do
      if account['player_password'].nil? ## nie ma hasła, tworzymy nowe
        current_user.catch_msg("Ustawiamy nowe haslo gracza.\n")

        pass = nil

        while pass.nil?
          current_user.dont_echo
          command = Engine.instance.read(current_user, "Podaj haslo jakim bedziesz sie logowac na swoje postaci: ")
          current_user.catch_msg("\n")
          if command.cmd.size < 5
            current_user.catch_msg("Haslo musi miec conajmniej 5 liter\n")
          else
            temp_pass = command.cmd

            current_user.dont_echo
            command = Engine.instance.read(current_user, "Potwierdz haslo: ")
            current_user.catch_msg("\n")
            if command.cmd != temp_pass
              current_user.catch_msg("Podane hasla nie zgadzaja sie!\n")
            else
              pass = command.cmd
            end
          end
        end

        pass = Digest::SHA1.hexdigest(pass)
        @model_account.save(account['id'], {:player_password => pass})
        current_user.catch_msg("Haslo na postac zostalo poprawnie utworzone.\n")
        break
      else ## mamy hasło, chcemy je zmienić
        current_user.catch_msg("Zmieniamy haslo gracza.\n")

        current_password = nil
        new_password = nil
        temp_pass = nil

        while new_password.nil?
          current_user.dont_echo
          current_password = Engine.instance.read(current_user, "Podaj aktualne haslo gracza: ")
          current_user.catch_msg("\n")

          if Digest::SHA1.hexdigest(current_password.cmd) != account['player_password']
            current_user.catch_msg("Aktualne haslo jest niepoprawne!\n")
          else
            current_user.dont_echo
            command = Engine.instance.read(current_user, "Podaj haslo jakim bedziesz sie logowac na swoje postaci: ")
            current_user.catch_msg("\n")
            if command.cmd.size < 5
              current_user.catch_msg("Haslo musi miec conajmniej 5 liter\n")
            else
              temp_pass = command.cmd

              current_user.dont_echo
              command = Engine.instance.read(current_user, "Potwierdz haslo: ")
              current_user.catch_msg("\n")
              if command.cmd != temp_pass
                current_user.catch_msg("Podane hasla nie zgadzaja sie!\n")
              else
                new_password = command.cmd
              end
            end
          end
        end

        new_password = Digest::SHA1.hexdigest(new_password)
        @model_account.save(account['id'], {:player_password => new_password})
        current_user.catch_msg("Haslo na postac zostalo poprawnie zmienione.\n")
        break
      end
    end

    Engine.instance.read(current_user, "Wcisnij enter. ")
  end

  ## opcja zakoncz - konczy edycje konta
  def manage_cmd_zakoncz(account)
    current_user.catch_msg("Zakonczono edycje konta.\n")
    false # zwraam 'false' zeby wyjsc z petli zarzadzania kontem

  end

  ## tworzenie nowego gracza
  def create_player(playername, account)
    params = {:account_id => account['id'], :name => playername.downcase, :created => false}

    @player_model.save(0, params)
    current_user.catch_msg "Postac o imieniu '" + playername.to_s + "' zostala utworzona.\n"
    Engine.instance.read(current_user, "Wcisnij enter. ")
    ## todo - zrobić tworzenie graczy
    #
    #
    #
    #    player = AccountPlayer.new(@name) # od razu robimy powiązanie z tym kontem
    #    player.name = playername.downcase
    #
    #    current_user.catch_msg("Podaj poprawna odmiane swojego imienia.\n")
    #    current_user.catch_msg("Mianownik: " + player.name + "\n")
    #
    #    player.mia = player.name
    #
    #    loop do
    #      command = Engine.instance.read(current_user, "Dopelniacz (kogo? / czego?): ")
    #      player.dop = command.cmd
    #      command = Engine.instance.read(current_user, "Celownik (komu? / czemu?): ")
    #      player.cel = command.cmd
    #      command = Engine.instance.read(current_user, "Biernik (kogo? / co?): ")
    #      player.bie = command.cmd
    #      command = Engine.instance.read(current_user, "Narzednik (z kim? / z czym?): ")
    #      player.nar = command.cmd
    #      command = Engine.instance.read(current_user, "Miejscownik (o kim? / o czym?): ")
    #      player.mie = command.cmd
    #
    #      current_user.catch_msg("Oto odmiana podana przez ciebie: \n")
    #      current_user.catch_msg(player.decline)
    #
    #      declination_correct = false
    #      loop do
    #        command = Engine.instance.read(current_user, "Czy odmiana jest poprawna? ([t]ak/[n]ie): ")
    #        if !command.cmd.match(/^(t|n|tak|nie)$/)
    #          current_user.catch_msg("Mozliwe odpowiedzi: [t]ak/[n]ie.\n")
    #        else
    #					if command.cmd.match(/^t/)
    #						declination_correct = true
    #					end
    #					break
    #        end
    #      end
    #
    #			if declination_correct
    #				break
    #			end
    #    end
    #
    #		begin
    #			player.save
    #			current_user.catch_msg("Postac #{player.name} zostala poprawnie stworzona. Mozesz sie na nia zalogowac.\n")
    #			if @players.nil?
    #				@players = []
    #			end
    #			@players << player.name
    #			self.save
    #		rescue
    #			current_user.catch_msg("Wystapil blad przy tworzeniu postaci.\n")
    #		end
    #

  end
end