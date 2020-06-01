# frozen_string_literal: true
require "sequel"

db = Sequel.connect("postgres://postgres:x@database:5432/postgres")
db.execute(%(CREATE DATABASE "rmud_test"))
