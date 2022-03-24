# frozen_string_literal: true

FactoryBot.define do
  factory :weapon, class: Entities::Game::Weapon do
    initialize_with { new(attributes) }
    skip_create

    id { ULID.generate }
    adjectives { ["prosty"] }
    name { "miecz" }
    rarity { Constants::Game::Item::Rarity::COMMON }

    hit_type { [Constants::Game::Weapon::HitType::PIERCE] }
    hand { Constants::Game::Weapon::Hand::SINGLE }
    dps { 1.0 }
    level { 10 }
    bonus { {} }
    durability { 100 }
    weight { 1.0 }
  end
end
