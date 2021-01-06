module Rmud; end

require "socket"
require "bundler"
Bundler.require

require "./database"

loader = Zeitwerk::Loader.for_gem
loader.log! unless ENV["STAGE"] == "test"
loader.ignore("./spec")
loader.ignore("./boot")
loader.ignore("./db")
loader.ignore("./gamedriver")
loader.ignore("./database.rb")
loader.ignore("./boot.rb")
loader.ignore("./ci.rb")
loader.setup

module Types
  include Dry.Types

  Room = Types.Instance(Entities::Room)
  PlayerObject = Types.Instance(Entities::Player)
  GameObject = Types.Instance(Entities::GameObject)
  MovableObject = Types.Instance(Entities::MovableObject)

  VOID = :void.freeze
end

Dry::Types.load_extensions(:monads)

ROOMS = Dry::Container.new

loader.eager_load

Engine::Rooms::Loader.load!(ROOMS)
