# frozen_string_literal: true
App.boot(:bundler) do
  init { require "bundler" }

  start { Bundler.require }
end
