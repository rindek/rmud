# frozen_string_literal: true

FactoryBot.define do
  factory :game_object, class: Entities::Game::GameObject do
    initialize_with { new(attributes) }
    skip_create
  end
end
