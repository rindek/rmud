require "dry/system/container"

class App < Dry::System::Container
  use :env

  configure do
    config.env = ENV["STAGE"] || "development"
    config.root = Pathname.new(__dir__)
  end
end

class GameContainer
  extend Dry::Container::Mixin
  register(:rooms, Dry::Container.new)
  register(:items, Dry::Container.new)
end

App.register(:game, GameContainer)

Dir[App.config.root.join("boot", "**", "*.rb")].sort.each { |file| require file }

PLAYERS = {}
