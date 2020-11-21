# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: Entities::Player do
    initialize_with { Entities::Player.new(**attributes) }
    skip_create

    model { build(:player_model) }
  end
end
