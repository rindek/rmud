# coding: utf-8

require './boot.rb'
require './core/efuns.rb'

set_server_environment("devel")

require './core/event.rb'
require './core/engine.rb'

def test_database
  adapter = DataMapper.repository(:default).adapter
  adapter.execute("SELECT NOW()")
end

if $0 == __FILE__
  begin

    # manualnie odpalamy garbage collector co 10 minut
    Alarm.new.repeat(600, 600) do
      puts "Wykonuje GC..."
      GC.start
    end

    ## konfigurujemy bazę
    DataMapper::Logger.new($stdout, :debug)

    ## konfigurujemy połączenie z bazą
    db_config = read_config("database")[server_environment]
    connection_string = "mysql://USER:PASS@HOST/DATABASE"
    connection_string["USER"] = db_config['username']
    connection_string["PASS"] = db_config['password']
    connection_string["HOST"] = db_config['host']
    connection_string["DATABASE"] = db_config['database']

    DataMapper.setup(:default, connection_string)

    ## testujemy połączenie
    begin
      test_database
    rescue DataObjects::ConnectionError
      puts $!
      Process.exit
    end

    ## Ładujemy wszystkie najpotrzebniejsze rzeczy
    Engine.instance.load_all
    
    ## Odpalamy nasłuchiwanie
    Engine.instance.accept_connections
  end
end
