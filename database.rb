# frozen_string_literal: true
require "logger"

config = {
  adapter: :postgres,
  user: "postgres",
  host: "database",
  database: "rmud_#{ENV["STAGE"]}",
}

Sequel.connect(config.merge(database: "postgres")) do |db|
  db.execute %(CREATE DATABASE #{config[:database]})
rescue Sequel::DatabaseError => e
  raise e unless e.cause.class == PG::DuplicateDatabase
end

puts "Connecting to #{config}..."

DB = Sequel.connect(config)
DB.loggers << Logger.new($stdout) unless ENV["STAGE"] == "test"

Sequel::Model.plugin :timestamps, update_on_create: true
