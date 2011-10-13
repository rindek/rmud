set_server_environment("devel")

require './core/event.rb'
require './core/engine.rb'

class Runner
  include Singleton
  
  def child
    @child
  end
  
  def running?
    return false if @connector.nil?
    !@connector.stopped?
  end
  
  def connector
    @connector
  end
  
  def test_database
    adapter = DataMapper.repository(:default).adapter
    adapter.execute("SELECT NOW()")
  end

  def configure!
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
    rescue DataObjects::SQLError
      puts $!
      puts "Can't establish connection to your database. Check your configuration and/or your db server, and try again".colorize(:red)
      Process.exit
    end
    
    ## requireujemy wrapper swiata
    require './world/init.rb'
  end

  def fork_and_run!
    @child = Process.fork do 
      Signal.trap("STOP") do
        p "caught STOP signal, stopping teh game"
        Engine.instance.shutdown!
      end      
      run!
    end
  end

  def run!
    self.configure!
    ## load oll nessecery files unless we want to re-run game
    Engine.instance.load_all
    
    ## Odpalamy nasłuchiwanie
    game_config = read_config("game")[server_environment]

    begin
      @connector = Connector.new(game_config["port"]) if @connector.nil?
      @connector.debug = true
      @connector.audit = true
      @connector.start
      log_notice("[engine, connector] - Server started")
      @connector.join
      log_notice("[engine, connector] - Server stopped")
      true
    rescue Exception => e
      message  = "#=================================\n"
      message += "# Error: #{$!}\n"
      message += "#=================================\n"
      e.backtrace.each do |msg|
        message += "# " + msg + "\n"
      end
      message += "#=================================\n"

      log_error("\n" + message) # na serwer
      false
    end
  end
  
  def stop!
    @connector.stop
    Process.exit
  end
end
