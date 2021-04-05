# frozen_string_literal: true
require "dry/system/components"

App.boot(:settings, from: :system) do
  require "dry/types"

  module T
    include Dry.Types
  end

  settings do
    key :host, T::String.default("0.0.0.0")
    key :port, T::Integer.default(2300)

    key :mongo_host, T::String.default("mongo")
    key :mongo_port, T::Integer.default(27_017)
    key :mongo_database, T::String.default("rmud_#{App.env}".freeze)

    key :redis_host, T::String.default("redis")
  end
end
