require 'eventmachine'
require 'digest/sha1'


require './boot'
require './core/efuns'
require './core/engine'

Engine.instance.load_important_files  
Engine.instance.load_all

module Rmud
  ## connection
  def post_init
    @player_connection = PlayerConnectionLib.new(self)
    @player_connection.input_handler = LoginHandler.new(@player_connection)
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

EventMachine::run do
  EventMachine::start_server 'localhost', 8000, Rmud
end


# client.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
# 
# user = User.new(client)
# 
# @@users.push(user)
# 
# set_current_user(user)
# 
# Engine.instance.welcome(user)
# accplayer = Login.instance.login(user)
# 
# if user.socket.closed?
#   return
# end
# 
# puts "Logujemy gracza " + accplayer['name'] + " do gry."
# user.nick = accplayer['name']
# 
# #    user.disconnect()
# player = Player.new(user, accplayer)
# 
# ## jeżeli gracz nie jest jeszcze do końca stworzony, to musi
# ## zostać przeniesiony do specjalnego miejsca, gdzie
# ## postać jest tworzona.
# 
# require './world/room.rb'
# room = World::Room.instance
# player.move(room)
# room.filter(Player, [player]).each do |p|
#   p.catch_msg(player.short.capitalize + " wchodzi do gry.\n")
# end
# 
# set_environment("game")
# loop do
#   if player.socket.nil?
#     break
#   end
# 
#   if player.socket.closed?
#     break
#   end
# 
#   command = self.class.read(player)
#   if command.nil?
#     # utracono połączenie, przenosimy do link_dead obiektu
#     # .. jak go zakoduje :-) na razie przenosimy do nil, czyli usuwamy ze swiata
#     player.move(nil)
#     break
#   end
# 
#   Engine.instance.serve(player, command)
# end