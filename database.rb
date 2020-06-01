# frozen_string_literal: true
require "logger"

DB = Sequel.connect(ENV["DATABASE_URL"] || "postgres://postgres@database:5432/rmud_#{ENV["STAGE"]}")
DB.loggers << Logger.new($stdout)

Sequel::Model.plugin :timestamps, update_on_create: true
