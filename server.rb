require 'core/efuns.rb'
require 'core/engine.rb'

require 'yaml'
require 'dbi'

require 'core/sql/sql.rb'

@game_environment = "devel"


puts "Testuje polaczenie z baza danych..."

def test_database
  config = read_config("database")

  connection_string = "DBI:Mysql:" + config[@game_environment]["database"] + ":" + config[@game_environment]["host"]

  begin
    DBI.connect(connection_string, config[@game_environment]["username"], config[@game_environment]["password"]) do |dbh|
      dbh.prepare("SELECT NOW()") do |sth|
        sth.execute
      end
    end
  rescue DBI::DatabaseError => e
    message =  ""
    message += "#=================================\n"
    message += "# Error: #{$!}\n"
    message += "#=================================\n"
    puts message
    exit
  end
end

test_database

if $0 == __FILE__
  begin

    # manualnie odpalamy garbage collector co 10 minut
    Alarm.new.repeat(600, 600) do
      puts "Wykonuje GC..."
      GC.start
    end

    Engine.instance.load_all
    Engine.instance.accept_connections
  end
end