require "dry/system/container"
require "dry/events/publisher"

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
App.register(:players, Concurrent::Hash.new)

Dir[App.config.root.join("boot", "**", "*.rb")].sort.each { |file| require file }

App.start(:bundler)
