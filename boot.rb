require "bundler"
Bundler.require

require "./database"

module Types
  include Dry.Types()
end

loader = Zeitwerk::Loader.for_gem
loader.log!
loader.ignore("./spec")
loader.ignore("./boot")
loader.ignore("./db")
loader.ignore("./gamedriver")
loader.ignore("./database.rb")
loader.ignore("./boot.rb")
loader.setup
loader.eager_load
