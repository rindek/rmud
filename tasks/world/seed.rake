# frozen_string_literal: true
namespace :world do
  task seed: :environment do
    ## Add default player
    Models::Player.find_or_create(name: "rindek") { |player| player.password = "rindek" }

    ## Add some rooms
    room1 = Models::Room.find_or_create(short: "short room1", long: "long room1")
    room2 = Models::Room.find_or_create(short: "short room2", long: "long room2")

    ## Add links between rooms
    Models::RoomExit.find_or_create(from_room_id: room1.id, to_room_id: String(room2.id), name: "wschod")
    Models::RoomExit.find_or_create(from_room_id: room2.id, to_room_id: String(room1.id), name: "zachod")
  end

  task seed_mongo: :environment do
    ## Add default player
    App[:mongo][:players]
      .find(name: "rindek")
      .first
      .then do |record|
        if record.nil?
          App[:mongo][:players].insert_one(
            name: "rindek",
            password: BCrypt::Password.create("rindek"),
            created_at: Time.now,
          )
        end
      end
  end
end
