# frozen_string_literal: true
require "dry/system/components"

App.boot(:settings, from: :system) do
  settings do
    key :host, Types::String.default("0.0.0.0")
    key :port, Types::Integer.default(2300)
  end
end
