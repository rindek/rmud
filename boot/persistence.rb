# frozen_string_literal: true
App.boot(:mongo) do |app|
  start do
    use :bundler

    Mongo::Logger.logger = Logger.new($stdout) unless App.env == "test"

    register(
      :mongo,
      Mongo::Client.new(
        [[App[:settings].mongo_host, App[:settings].mongo_port].join(":")],
        database: App[:settings].mongo_database,
      ),
    )
  end
end
