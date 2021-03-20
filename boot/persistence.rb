# frozen_string_literal: true
App.boot(:persistence) do
  start do
    use :bundler
    use :logger

    config = {
      adapter: :postgres,
      user: App[:settings].db_user,
      host: App[:settings].db_host,
      database: App[:settings].db_name,
      password: App[:settings].db_pass,
    }

    Sequel.connect(config.merge(database: "postgres")) do |db|
      db.execute "CREATE DATABASE #{config[:database]}"
    rescue Sequel::DatabaseError => e
      raise e unless e.cause.class == PG::DuplicateDatabase
    end

    puts "Connecting to #{config}..."

    db = Sequel.connect(config)
    db.loggers << Logger.new($stdout) unless App.env == "test"

    Sequel::Model.plugin :timestamps, update_on_create: true

    register(:database, db)
  end
end
