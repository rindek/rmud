# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: Entities::Player do
    initialize_with { Entities::Player.new(**attributes) }
    skip_create

    sequence(:id) { |n| n }
    name { "player" }
    password { "password" }
  end
end
