require 'singleton'

require './core/modules/direction.rb'

require './core/game_object.rb'

require './core/connector.rb'
require './core/alarm.rb'

require './core/player.rb'

## konfiguracja bazy danych


class Engine
  include Singleton

  attr_accessor :accounts

  def initialize
    @accounts = []
  end

  def load_models
    model_dir = Dir.pwd + "/core/models/"

    ## model.rb jest wymagany
    ## require (model_dir + "model.rb")

    Dir.entries(model_dir).each do |file|
      if file.match(/.+\.rb/)
        puts "Loading " + file + "...\n"
        require (model_dir + file)
      end
    end

    DataMapper.finalize
  end

  def load_souls
    souls_dirs = [Dir.pwd + "/core/commands/live/"]

    souls_dirs.each do |soul_dir|
      Dir.entries(soul_dir).each do |file|
        if file.match(/.+.rb/)
          require (soul_dir + file)
        end
      end
    end
  end

  ## ładujemy wszystkie pliki znajdujące się w ['core', 'gamedriver', 'mudlib']
  def load_all
    dirs = [Dir.pwd + "/core/", Dir.pwd + "/gamedriver/", Dir.pwd + "/mudlib/"]
    dirs.each do |subdir|
      load_dir_recursive(subdir)
    end
  end
  
  def load_dir_recursive(dir)
    Dir.entries(dir).each do |file|
      if file.match(/.+.rb/)
        require (dir + file)
      else
        if file != "." && file != ".." && File.directory?(dir + file)
          load_dir_recursive(dir + file + "/")
        end
      end
    end
  end

  def read(user, prompt = "> ")
    @connector.read(user, prompt)
  end

  def welcome(user)
    user.catch_msg(" Witaj! \n")
    user.catch_msg(" Aby zalozyc nowe konto wpisz 'nowe konto' \n")
    user.catch_msg(" Aby zalogowac sie na konto wpisz 'konto _nazwakonta_' \n")
    user.catch_msg(" Aby zalogowac sie do gry, wpisz imie swojej postaci. \n")
  end

  def accept_connections
    @connector = Connector.new(4001)
    @connector.debug = true
    @connector.audit = true
    @connector.start
    puts "Server started"
    @connector.join
    puts "Server terminated"
  rescue Exception => e
    puts "Something went wrong"
  end

  ## user => Player
  def serve(user, command)
    begin
      fail_message("Slucham?\n")
      # user.catch_msg(command.cmd + "\n")

      # priorytet szukania komend
      # 1. obiekty, które mam przy sobie
      # 2. obiekty, ktore są w moim otoczeniu
      # 3. obiekt lokacji
      # 4. obiekty soula

      ## najpierw obiekty, które mam przy sobie
      inv = this_player.inventory
      inv.each do |obj|
        if obj.respond_to_command?(command)
          func = obj.get_command(command)
          return if func.call(command) != false
        end
      end

      ## obiekty mojego otoczenia
      inv = this_player.environment.inventory
      inv.each do |obj|
        if obj.respond_to_command?(command)
          func = obj.get_command(command)
          return if func.call(command) != false
        end
      end

      ## obiekty lokacji
      room = this_player.environment
      if room.respond_to_command?(command)
        func = room.get_command(command)
        return if func.call(command) != false
      end

      ## na końcu szukamy po obiektach soula
      souls = this_player.get_souls
      souls.each do |soul|
        if soul.respond_to_command?(command)
          func = soul.get_command(command)
          return if func.call(command) != false
        end
      end

      ## jeżeli dotarliśmy do tego miejsca oznacza to, że wszystkie
      ## poprzednie komendy zakończyly się failem, wyświetlamy fail message
      this_player.catch_msg(get_fail_message)

      if command.cmd =~ /env/
        p user.environment
        puts "ilosc obiektow w tym pokoju: " + user.environment.inventory.count.to_s
        print "exity: "
        p user.environment.get_exits
      end

      #      if command.cmd == "i"
      #        user.inventory.each do |obj|
      #          user.catch_msg(obj.short + ", ")
      #        end
      #        user.catch_msg("\n")
      #      end

      if command.cmd =~ /debugger/
        debugger
      end

      if command.cmd =~ /pilka/
#        require './world/pilka.rb'
        World::Pilka.new.move(user)
        user.catch_msg("masz nowa pilke!\n")
      end

    rescue Exception => e
      message  = "#=================================\n"
      message += "# Command: " + command.to_s + "\n"
      if current_environment
        message += "# Environment: " + current_environment + "\n"
      end
      message += "#=================================\n"
      message += "# Error: #{$!}\n"
      message += "#=================================\n"
      e.backtrace.each do |msg|
        message += "# " + msg + "\n"
      end
      message += "#=================================\n"

      puts message # na serwer
      user.catch_msg(message) # na ekran
    end
  end
end
