# frozen_string_literal: true

FactoryBot.define do
  factory :engine_client, class: Engine::Client do
    initialize_with { Engine::Client.new(**attributes) }
    skip_create

    em_connection { FakeSocketClient.new(nil) }
  end
end
