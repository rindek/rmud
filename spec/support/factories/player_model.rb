# frozen_string_literal: true

FactoryBot.define do
  factory :player_model, class: Models::Player do
    name { "player" }
    password { "pass" }
  end
end
