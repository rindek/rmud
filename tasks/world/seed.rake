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
    App[:mongo][:players].delete_many
    App[:mongo][:rooms].delete_many

    ## Add default player
    App[:mongo][:players].insert_one(name: "rindek", password: BCrypt::Password.create("rindek"), created_at: Time.now)

    ## Add rooms
    room1 =
      begin
        App[:mongo][:rooms].insert_one(short: "short room1", long: "long room1", exits: [], created_at: Time.now)
        App[:mongo][:rooms].find(short: "short room1").first
      end

    room2 =
      begin
        App[:mongo][:rooms].insert_one(short: "short room2", long: "long room2", exits: [], created_at: Time.now)
        App[:mongo][:rooms].find(short: "short room2").first
      end

    ## add link between rooms
    App[:mongo][:rooms].update_one(
      { _id: room1["_id"] },
      { "$set" => { exits: [{ to: room2["_id"], name: "wschod" }] } },
    )

    App[:mongo][:rooms].update_one(
      { _id: room2["_id"] },
      { "$set" => { exits: [{ to: room1["_id"], name: "zachod" }] } },
    )
  end
end
