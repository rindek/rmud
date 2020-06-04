# frozen_string_literal: true
require "logger"

connection_string = ENV["DATABASE_URL"] || "postgres://postgres@database:5432/rmud_#{ENV["STAGE"]}"
puts "Connecting to #{connection_string}..."

DB = Sequel.connect(connection_string)
DB.loggers << Logger.new($stdout) unless ENV["STAGE"] == "test"

Sequel::Model.plugin :timestamps, update_on_create: true
