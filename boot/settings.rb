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

    key :db_user, T::String.default("postgres")
    key :db_host, T::String.default("database")
    key :db_name, T::String.default("rmud_#{App.env}".freeze)
    key :db_pass, T::String.default("x")
  end
end
