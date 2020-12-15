# frozen_string_literal: true
require "logger"

config = {
  adapter: :postgres,
  user: ENV["DB_USER"] || "postgres",
  host: ENV["DB_HOST"] || "database",
  database: ENV["DB_NAME"] || "rmud_#{ENV["STAGE"]}",
  password: ENV["DB_PASS"] || "x",
}

Sequel.connect(config.merge(database: "postgres")) do |db|
  db.execute "CREATE DATABASE #{config[:database]}"
rescue Sequel::DatabaseError => e
  raise e unless e.cause.class == PG::DuplicateDatabase
end

puts "Connecting to #{config}..."

DB = Sequel.connect(config)
DB.loggers << Logger.new($stdout) unless ENV["STAGE"] == "test"

Sequel::Model.plugin :timestamps, update_on_create: true
