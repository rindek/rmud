module Rmud; end

require "socket"
require "bundler"
Bundler.require

require "./database"

loader = Zeitwerk::Loader.for_gem
loader.log!
loader.ignore("./spec")
loader.ignore("./boot")
loader.ignore("./db")
loader.ignore("./gamedriver")
loader.ignore("./database.rb")
loader.ignore("./boot.rb")
loader.setup

module Types
  include Dry.Types()
  GameObject = Types.Instance(Entities::GameObject)
  MovableObject = Types.Instance(Entities::MovableObject)
end

ROOMS = Dry::Container.new

loader.eager_load

Engine::Rooms::Loader.load!(ROOMS)
