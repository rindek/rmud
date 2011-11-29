# coding: utf-8
require './boot.rb'
require './core/efuns.rb'

require 'dm-migrations/migration_runner'

set_server_environment("devel")

## konfigurujemy bazę
DataMapper::Logger.new($stdout, :debug)

## konfigurujemy połączenie z bazą
db_config = read_config("database")[server_environment]

if db_config.nil?
  puts "Database config not found! Check config/database.yml for '#{server_environment}' environment"
  Process.exit
end

connection_string = "mysql://USER:PASS@HOST/DATABASE"
connection_string["USER"] = db_config['username']
connection_string["PASS"] = db_config['password']
connection_string["HOST"] = db_config['host']
connection_string["DATABASE"] = db_config['database']

DataMapper.setup(:default, connection_string)
DataMapper.logger.debug( "Starting Migration" )

## ladujemy pliki z db/migrations
Dir.glob(RMUD_ROOT + "/db/migrations/*.rb").each do |file|
  require file
end


if $0 == __FILE__
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end
