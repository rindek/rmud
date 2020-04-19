# frozen_string_literal: true
require "logger"

DB = Sequel.connect("postgres://postgres@localhost:5557/rmud_dev")
DB.loggers << Logger.new($stdout)

Sequel::Model.plugin :timestamps, update_on_create: true
