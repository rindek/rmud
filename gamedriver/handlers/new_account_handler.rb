class NewAccountHandler < Handler
  def init
    @state = :account_name
    
    @name, @password, @email = nil, nil, nil
  end
  
  def prompt
    case @state
    when :account_name then
      "Podaj nazwe dla swojego konta: "
    when :account_password then
      "Podaj haslo na konto: "
    when :account_password_confirmation then
      "Potwierdz haslo: "
    when :account_email then
      "Podaj email na konto: "
    else
      "Powazny blad... ?"
    end
  end
  
  def input(data)
    echo_on if [:account_password, :account_password_confirmation].include?(@state)
    send(@state, data.to_c)
  end
  
  def account_name(data)
    if /^[A-Za-z]+$/.match(data.cmd)
      if data.cmd.size < 5
        oo("Nazwa konta musi skladac sie z conajmniej 5 liter")
      elsif !Models::Account.first(:name => data.cmd).nil?
        oo("Ta nazwa konta jest juz zajeta, wybierz inna")
      else
        @name = data.cmd.downcase
        oo("Twoja nazwa konta to '#{@name}'")
        @state = :account_password
        echo_off
      end
    else
      oo("Nazwa konta moze skladac sie tylko z liter a-z")
    end
  end
  
  def account_password(data)
    oo
    if data.cmd.size < 5
      oo("Haslo musi miec conajmniej 5 liter")
    else
      @password = Digest::SHA1.hexdigest(data.cmd)
      @state = :account_password_confirmation
      echo_off
    end
  end
  
  def account_password_confirmation(data)
    oo
    if Digest::SHA1.hexdigest(data.cmd) != @password
      oo("Podane hasla sie nie zgadzaja, sprobuj ponownie")
      @state = :account_password
      echo_off
    else
      @state = :account_email
    end
  end
  
  def account_email(data)
    if !email_validate(data.cmd)
      oo("Niepoprawny format adresu email")
    else
      @email = data.cmd
      create_account!
      oo("Konto zostalo poprawnie utworzone. Mozesz sie na nie zalogowac wpisujac 'konto #{@name}'")
      @player_connection.input_handler = AnyKeyNextHandler.new(@player_connection, LoginHandler)
    end
  end
  
  private
  def email_validate(email)
    email.match(/^[0-9A-Za-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end
  
  def create_account!
    Models::Account.create(:name => @name, :email => @email, :password => @password, :player_password => nil)
  end
end