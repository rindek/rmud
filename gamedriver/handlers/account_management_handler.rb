# coding: utf-8
class AccountManagementHandler < Handler
  def init(account)
    @account = account
    @state = :menu
  end

  def prompt
    case @state
    when :menu
      show_menu
      "Wybierz opcje: "
    else
      "Powazny blad... ?"
    end
  end

  def input(data)
    send(@state, data.to_c)
  end

  def show_menu
    oo("[lista] - lista stworzonych postaci")
    oo("[nowa] - tworzenie nowej postaci")
    oo("[haslo] - utworzenie/zmiana hasla postaci")
#    oo("[4] - kontynuacja tworzenia postaci")
    oo("[zakoncz] - zakonczenie zarzadzania kontem, powrot do ekranu logowania")
  end

  def menu(data)
    states = [:lista, :nowa, :haslo, :zakoncz]
    unless states.include?(data.to_sym)
      oo("Nie ma takiej opcji, sprobuj ponownie.")
    else
      send(data.to_sym)
    end
  end

  def lista
    players = @account.players

    if players.size == 0
      oo("Nie masz stworzonych zadnych postaci.")
    else
      oo("Oto lista twoich postaci:")
      players.each do |player|
        oo(" * #{player['name'].capitalize}")
      end
    end
    @player_connection.input_handler = AnyKeyNextHandler.new(@player_connection, self)
  end

  def nowa
    if @account['player_password'].nil?
      oo("Musisz najpierw ustawic haslo na postac korzystajac z opcji 'haslo'")
      @player_connection.input_handler = AnyKeyNextHandler.new(@player_connection, self)
    else
      @player_connection.input_handler = AccountManagementPlayerCreationHandler.new(@player_connection)
      @player_connection.input_handler.init(@account)
    end
  end

  def haslo
    @player_connection.input_handler = AccountManagementPasswordChangerHandler.new(@player_connection)
    @player_connection.input_handler.init(@account, self)
  end

  def zakoncz
    oo("Zakonczono edycje konta.")
    @player_connection.input_handler = LoginHandler.new(@player_connection)
  end
end
