# coding: utf-8

require './boot.rb'
require './core/efuns.rb'

set_server_environment("devel")

require './core/engine.rb'


def test_database
  adapter = DataMapper.repository(:default).adapter
  adapter.execute("SELECT NOW()")
end

if $0 == __FILE__
  begin

    ## konfigurujemy bazę
    DataMapper::Logger.new($stdout, :debug)

    ## konfigurujemy połączenie z bazą
    db_config = read_config("database")[server_environment]

    if db_config.nil?
      puts "Database config not found! Check config/database.yml for '" + server_environment + "' environment"
      Process.exit
    end

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

    Engine.instance.load_models
    puts "All models are loaded. Next step will create in your database".colorize(:green)
    puts "This will ".colorize(:green) + "WIPE".colorize(:red) +" any existing tables if you have any already".colorize(:green)
    puts "Database we're going to migrate to is: ".colorize(:green) + (db_config['database'] + "@" + db_config["host"]).colorize(:red)

    STDOUT.flush
    answer = nil
    loop do
      if answer != 'yes' && answer != 'no'
        puts "Type in '"+ "yes".colorize(:green) +"' to process, '"+ "no".colorize(:red) +"' to cancel..."
        answer = gets.chomp
      else
        break
      end
    end

    if answer == 'no'
      puts "Installation cancelled".colorize(:red)
      Process.exit
    end

    DataMapper.auto_migrate!

    puts "Database has been installed properly, now run: 'ruby server.rb'".colorize(:green)
  end
end
