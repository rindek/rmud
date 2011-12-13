require 'singleton'

# require './core/modules/direction.rb'

# require './core/game_object.rb'

# require './core/connector.rb'
# require './core/alarm.rb'

# require './core/player.rb'

## konfiguracja bazy danych

require './core/lang/pl'

class Engine
  include Singleton

  attr_accessor :accounts

  def initialize
    @accounts = []
  end

  def load_models
    model_dir = Dir.pwd + "/core/models/"

    Dir.entries(model_dir).each do |file|
      if file.match(/.+\.rb/)
        require (model_dir + file)
      end
    end

    DataMapper.finalize
  end

  ## ładujemy wszystkie niezbędne pliki
  def load_important_files
    log_notice("[code] - Loading all important files")
    files = [
      Dir.pwd + "/gamedriver/handlers/base_handler.rb",
      Dir.pwd + "/gamedriver/handlers/handler.rb",
      Dir.pwd + "/gamedriver/handlers/next_handler.rb",
    ]
    files.each do |file|
      require file
    end
    log_notice("[core] - Finished loading all important files")
  end

  ## ładujemy wszystkie pliki znajdujące się w ['core', 'gamedriver', 'mudlib']
  def load_all
    log_notice("[core] - Loading all files from " + ['core', 'gamedriver', 'mudlib'].join(", ") + " dirs")
    dirs = [Dir.pwd + "/core/", Dir.pwd + "/gamedriver/", Dir.pwd + "/mudlib/"]
    dirs.each do |subdir|
      load_dir_recursive(subdir)
    end
    log_notice("[core] - Finished loading all files")
  end
  
  ## przeladowujemy wszystkie pliki znajdujace sie w ['core', 'gamedriver', 'mudlib']
  def reload_all
    log_notice("[core] - Reloading all files from " + ['core', 'gamedriver', 'mudlib'].join(", ") + " dirs")
    dirs = [Dir.pwd + "/core/", Dir.pwd + "/gamedriver/", Dir.pwd + "/mudlib/"]
    dirs.each do |subdir|
      load_dir_recursive(subdir, true)
    end
    log_notice("[core] - Finished reloading all files")
  end
  
  def load_dir_recursive(dir, are_we_loading = false)
    Dir.entries(dir).sort.each do |file|
      if file.match(/.+.rb/)
        if are_we_loading
          load (dir + file)
        else
          require (dir + file)
        end
      else
        if file != "." && file != ".." && File.directory?(dir + file)
          load_dir_recursive(dir + file + "/", are_we_loading)
        end
      end
    end
  end



  # def read(user, prompt = "> ")
  #   Connector.read(user, prompt)
  # end

  # def welcome(user)
  #   user.catch_msg(" Witaj! \n")
  #   user.catch_msg(" Aby zalozyc nowe konto wpisz 'nowe konto' \n")
  #   user.catch_msg(" Aby zalogowac sie na konto wpisz 'konto _nazwakonta_' \n")
  #   user.catch_msg(" Aby zalogowac sie do gry, wpisz imie swojej postaci. \n")
  # end

#   def accept_connections
#     game_config = read_config("game")[server_environment]
    
#     @connector = Connector.new(game_config["port"]) if @connector.nil?
#     @connector.debug = true
#     @connector.audit = true
#     @connector.start
#     log_notice("[engine, connector] - Server started")
#     @connector.join_with_terminal
#     log_notice("[engine, connector] - Server terminated")
#   rescue Exception => e
#       message  = "#=================================\n"
#       if current_environment
#         message += "# Environment: " + current_environment + "\n"
#       end
#       message += "#=================================\n"
#       message += "# Error: #{$!}\n"
#       message += "#=================================\n"
#       e.backtrace.each do |msg|
#         message += "# " + msg + "\n"
#       end
#       message += "#=================================\n"

#       log_error("\n" + message) # na serwer
#   end

#   ## user => Player
#   def serve(user, command)
#     begin
#       fail_message("Slucham?\n")
#       # user.catch_msg(command.cmd + "\n")

#       # priorytet szukania komend
#       # 1. obiekty, które mam przy sobie
#       # 2. obiekty, ktore są w moim otoczeniu
#       # 3. obiekt lokacji
#       # 4. obiekty soula

#       ## najpierw obiekty, które mam przy sobie
#       inv = this_player.inventory
#       inv.each do |obj|
#         if obj.respond_to_command?(command)
#           func = obj.get_command(command)
#           return if func.call(command) != false
#         end
#       end

#       ## obiekty mojego otoczenia
#       inv = this_player.environment.inventory
#       inv.each do |obj|
#         if obj.respond_to_command?(command)
#           func = obj.get_command(command)
#           return if func.call(command) != false
#         end
#       end

#       ## obiekty lokacji
#       room = this_player.environment
#       if room.respond_to_command?(command)
#         func = room.get_command(command)
#         return if func.call(command) != false
#       end

#       ## na końcu szukamy po obiektach soula
#       souls = this_player.get_souls
#       souls.each do |soul|
#         if soul.respond_to_command?(command)
#           func = soul.get_command(command)
#           return if func.call(command) != false
#         end
#       end

#       ## jeżeli dotarliśmy do tego miejsca oznacza to, że wszystkie
#       ## poprzednie komendy zakończyly się failem, wyświetlamy fail message
#       this_player.catch_msg(get_fail_message)

#       if command.cmd =~ /env/
#         p user.environment
#         puts "ilosc obiektow w tym pokoju: " + user.environment.inventory.count.to_s
#         print "exity: "
#         p user.environment.get_exits
#       end

#       #      if command.cmd == "i"
#       #        user.inventory.each do |obj|
#       #          user.catch_msg(obj.short + ", ")
#       #        end
#       #        user.catch_msg("\n")
#       #      end

#       if command.cmd =~ /debugger/
#         debugger
#       end

#       if command.cmd =~ /pilka/
# #        require './world/pilka.rb'
#         World::Pilka.new.move(user)
#         user.catch_msg("masz nowa pilke!\n")
#       end

#     rescue Exception => e
#       message  = "#=================================\n"
#       message += "# Command: " + command.to_s + "\n"
#       if current_environment
#         message += "# Environment: " + current_environment + "\n"
#       end
#       message += "#=================================\n"
#       message += "# Error: #{$!}\n"
#       message += "#=================================\n"
#       e.backtrace.each do |msg|
#         message += "# " + msg + "\n"
#       end
#       message += "#=================================\n"

#       puts message # na serwer
#       user.catch_msg(message) # na ekran
#     end
#   end
  
#   def shutdown!
#     World::Wrapper.before_shutdown
#     Runner.instance.stop!
#   end
end
