class ConnectionsJar
  @@connections = []

  def self.add(connection)
    @@connections << connection
  end

  def self.remove(connection)
    @@connections.delete(connection)
  end

  def self.connections
    @@connections
  end

  def self.count
    @@connections.count
  end
end


module RmudConnector
  ## connection
  def post_init
    @player_connection = PlayerConnectionLib.new(self, LoginHandler)
    @player_connection.print(File.read("doc/LOGIN_MESSAGE"))

    # port, ip = Socket.unpack_sockaddr_in(self.get_peername)
    # if ip == "127.0.0.1" && autolog
    #   log_notice("[Rmud::post_init] - auto logging in Rindek")
    #   player = Std::Player.new(@player_connection, Models::Player.find_by(:name => "rindek"))
    #   room   = World::Rooms::Room.instance
    #   player.move(room)
    #   @player_connection.input_handler = GameHandler.new(@player_connection)
    #   @player_connection.input_handler.init(player)
    # end
    ## prompt for next command
    @player_connection.input_handler.send_prompt

    ConnectionsJar.add @player_connection
  end
  
  ## input
  def receive_data(data)
    data = preprocess_input(data)
    return if data == ''

    result = proc do
      begin
        @player_connection.input_handler.input(data)
      rescue Exception => e
        @player_connection.println("Wystapil powazny blad.")
        message  = "#=================================\n"
        message += "# Error: #{e.class}: #{$!}\n"
        message += "# Environment: " + Rmud.env + "\n"
        message += "#=================================\n"
        e.backtrace.each do |msg|
          message += "# " + msg + "\n"
        end
        message += "#=================================\n"
        puts message
      end
    end

    callback = proc { |r| @player_connection.input_handler.send_prompt }

    EventMachine.defer(result, callback)
  end
  
  ## disconnection
  def unbind
    ConnectionsJar.remove @player_connection

    @player_connection.input_handler = nil
    @player_connection = nil
  end
  
  def preprocess_input(string)
    # combine CR+NULL into CR
    string = string.gsub(/#{CR}#{NULL}/no, CR)

    # combine EOL into "\n"
    string = string.gsub(/#{EOL}/no, "\n")

    string.gsub!(/#{IAC}(
        [#{IAC}#{AO}#{AYT}#{DM}#{IP}#{NOP}]|
        [#{DO}#{DONT}#{WILL}#{WONT}]
        [#{OPT_BINARY}-#{OPT_COMPRESS2}#{OPT_EXOPL}]|
        #{SB}[^#{IAC}]*#{IAC}#{SE}
        )/xno) do
      if    IAC == $1  # handle escaped IAC characters
        IAC
      elsif AYT == $1  # respond to "IAC AYT" (are you there)
        send_data("nobody here but us pigeons" + EOL)
        ''
      elsif DO == $1[0,1]  # respond to "IAC DO x"
        if OPT_BINARY == $1[1,1]
          send_data(IAC + WILL + OPT_BINARY)
        end
        ''
      elsif DONT == $1[0,1]  # respond to "IAC DON'T x" with "IAC WON'T x"
        ''
      elsif WILL == $1[0,1]  # respond to "IAC WILL x"
        if OPT_BINARY == $1[1,1]
          send_data(IAC + DO + OPT_BINARY)
        elsif OPT_ECHO == $1[1,1]
          send_data(IAC + DO + OPT_ECHO)
        elsif OPT_SGA  == $1[1,1]
          send_data(IAC + DO + OPT_SGA)
        elsif OPT_COMPRESS2 == $1[1,1]
          send_data(IAC + DONT + OPT_COMPRESS2)
        else
          send_data(IAC + DONT + $1[1..1])
        end
        ''
      elsif WONT == $1[0,1]  # respond to "IAC WON'T x"
        if OPT_ECHO == $1[1,1]
          send_data(IAC + DONT + OPT_ECHO)
        elsif OPT_SGA  == $1[1,1]
          send_data(IAC + DONT + OPT_SGA)
        else
          send_data(IAC + DONT + $1[1..1])
        end
        ''
      else
        ''
      end
    end
    return string.chomp
  end
end
