# frozen_string_literal: true

FactoryBot.define do
  factory :room, class: Entities::Room do
    initialize_with { Entities::Room.new(**attributes) }
    skip_create

    id { BSON::ObjectId.new }
    short { "A room" }
    long { "Long description of the room" }

    exits { [] }
  end
end
