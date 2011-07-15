require 'core/efuns.rb'

set_server_environment("devel")

require 'core/engine.rb'

require 'yaml'
require 'dbi'

require 'core/sql/sql.rb'


def test_database
  config = read_config("database")[server_environment]

  connection_string = "DBI:Mysql:" + config["database"] + ":" + config["host"]

  begin
    DBI.connect(connection_string, config["username"], config["password"]) do |dbh|
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

puts "Testuję bazę danych..."
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

