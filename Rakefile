require "sequel/rake"
Sequel::Rake.load!

require "./database"
Sequel::Rake.configure do
  set :connection, DB
end
