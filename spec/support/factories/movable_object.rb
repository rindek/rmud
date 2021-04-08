# frozen_string_literal: true

FactoryBot.define do
  factory :movable_object, class: Entities::Game::MovableObject do
    initialize_with { new(attributes) }
    skip_create
  end
end
