# frozen_string_literal: true

FactoryBot.define do
  factory :db_player, class: Entities::DB::Player do
    initialize_with { Entities::DB::Player.new(**attributes) }
    skip_create

    _id { BSON::ObjectId.new }
    name { "player" }
    password { "password" }
  end

  factory :game_player, class: Entities::Game::Player do
    initialize_with { Entities::Game::Player.new(**attributes) }
    skip_create

    data { build(:db_player) }
    client { build(:engine_client) }
  end
end
