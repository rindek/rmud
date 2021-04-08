# frozen_string_literal: true
namespace :world do
  task seed: :environment do
    State::Player.clear("rindek")
    App[:mongo][:players].delete_many
    App[:mongo][:rooms].delete_many

    ## Add default player
    App[:mongo][:players].insert_one(name: "rindek", password: BCrypt::Password.create("rindek"), created_at: Time.now)

    App[:mongo][:players].insert_one(name: "drugi", password: BCrypt::Password.create("rindek"), created_at: Time.now)
  end
end
