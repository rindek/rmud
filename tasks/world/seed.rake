# frozen_string_literal: true
namespace :world do
  task seed: :environment do
    App[:mongo][:players].delete_many
    App[:mongo][:rooms].delete_many

    ## Add default player
    App[:mongo][:players].insert_one(
      room_id: "spawn",
      name: "rindek",
      password: BCrypt::Password.create("rindek"),
      created_at: Time.now,
    )

    ## Add rooms
    room1 =
      begin
        App[:mongo][:rooms].insert_one(
          short: "short room1",
          long: "long room1",
          exits: [],
          objects: [],
          created_at: Time.now,
        )
        App[:mongo][:rooms].find(short: "short room1").first
      end

    room2 =
      begin
        App[:mongo][:rooms].insert_one(
          short: "short room2",
          long: "long room2",
          exits: [],
          objects: [],
          created_at: Time.now,
        )
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
