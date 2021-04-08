# frozen_string_literal: true
App.boot(:logger) do
  init { require "logger" }
  start { register(:logger, Logger.new($stdout)) }
end
