# frozen_string_literal: true

FactoryBot.define do
  factory :game_object, class: Entities::GameObject do
    initialize_with { new(attributes) }
    skip_create
  end
end
