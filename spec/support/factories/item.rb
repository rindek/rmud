# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: Entities::Game::Item do
    initialize_with { new(attributes) }
    skip_create

    id { ULID.generate }
    adjectives { ["mała"] }
    name { "piłka" }
    rarity { Constants::Game::Item::Rarity::COMMON }
  end
end
