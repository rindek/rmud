set_server_environment("devel")

require './core/event.rb'
require './core/engine.rb'

class Runner
  def self.running?
    return false if @connector.nil?
    !@connector.stopped?
  end
  
  def self.connector
    @connector
  end
  
  def self.test_database
    adapter = DataMapper.repository(:default).adapter
    adapter.execute("SELECT NOW()")
  end

  def self.configure!
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
      self.test_database
    rescue DataObjects::ConnectionError
      puts $!
      Process.exit
    end
    
    ## requireujemy wrapper swiata
    require './world/init.rb'
  end

  def self.run!
    self.configure!
    
    ## Ładujemy wszystkie najpotrzebniejsze rzeczy
    Engine.instance.load_all
    
    ## Odpalamy nasłuchiwanie
    game_config = read_config("game")[server_environment]

    begin
      @connector = Connector.new(game_config["port"]) if @connector.nil?
      @connector.debug = true
      @connector.audit = true
      @connector.start
      log_notice("[engine, connector] - Server started")
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
  
  def self.stop!
    @connector.stop
  end
end
