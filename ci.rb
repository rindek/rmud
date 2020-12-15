# frozen_string_literal: true
require "sequel"

db = Sequel.connect("postgres://postgres:#{ENV["DB_PASS"]}@#{ENV["DB_HOST"]}:5432/postgres")
db.execute("CREATE DATABASE \"#{ENV["DB_NAME"]}\"")
