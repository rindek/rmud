# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: Entities::Player do
    initialize_with { Entities::Player.new(**attributes) }
    skip_create

    id { BSON::ObjectId.new }
    name { "player" }
    password { "password" }
    room_id { "" }
  end
end
