Dir.chdir(File.dirname(__FILE__))

require './boot'

require 'digest/sha1'

require './core/efuns'
require './core/engine'

Engine.instance.load_important_files  
Engine.instance.load_all

module Rmud
  # include AutoCode
  # auto_load true, :directories => [ :world ]

  ## connection
  def post_init
    @player_connection = PlayerConnectionLib.new(self)
    @player_connection.input_handler = LoginHandler.new(@player_connection)
    @player_connection.print(File.read("doc/LOGIN_MESSAGE"))

    port, ip = Socket.unpack_sockaddr_in(self.get_peername)
    if ip == "127.0.0.1" && autolog
      log_notice("[Rmud::post_init] - auto logging in Rindek")
      player = Std::Player.new(@player_connection, Models::Player.first(:name => 'rindek').id)
      room   = World::Rooms::Room.instance
      player.move(room)
      @player_connection.input_handler = GameHandler.new(@player_connection)
      @player_connection.input_handler.init(player)
    end
    ## prompt for next command
    @player_connection.input_handler.send_prompt
  end
  
  ## input
  def receive_data(data)
    data = preprocess_input(data)
    return if data == ''
    @player_connection.input_handler.input(data)
    ## prompt for next command
    @player_connection.input_handler.send_prompt
  end
  
  ## disconnection
  def unbind
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
    return string
  end
end

set_server_environment("devel")

DataMapper::Logger.new($stdout, :debug)

## konfigurujemy połączenie z bazą
db_config = read_config("database")[server_environment]
connection_string = "mysql://USER:PASS@HOST/DATABASE"
connection_string["USER"] = db_config['username']
connection_string["PASS"] = db_config['password']
connection_string["HOST"] = db_config['host']
connection_string["DATABASE"] = db_config['database']

DataMapper.setup(:default, connection_string)

shall_i_restart(true)

def autolog
  true
end

EventMachine::run do
  load_world ## :-(

  server_config = read_config("game")[server_environment]
  log_notice("[server.rb] - accepting connections on #{server_config["host"]}:#{server_config["port"]}")

  before_start

  EventMachine::start_server server_config["host"], server_config["port"], Rmud
end

if shall_i_restart?
  Kernel.exec("ruby server.rb")
end

