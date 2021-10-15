# frozen_string_literal: true
App.boot(:rollbar) do |app|
  init { require "rollbar" }
  start do
    Rollbar.configure do |config|
      config.access_token = App[:settings].rollbar_token
      config.environment = App.env
      config.use_async = true
      config.async_handler =
        Proc.new { |payload| Concurrent::Promise.execute { Rollbar.process_from_async_handler(payload) } }
    end
  end
end
