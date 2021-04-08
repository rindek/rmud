# frozen_string_literal: true

FactoryBot.define do
  factory :room, class: Entities::Game::Room do
    initialize_with { Entities::Game::Room.new(**attributes) }
    skip_create

    id { SecureRandom.uuid }
    short { "A room" }
    long { "Long description of the room" }

    exits { [] }
  end
end
