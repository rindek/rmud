require "dry/system/container"

class App < Dry::System::Container
  use :env

  configure do |config|
    config.env = ENV["STAGE"] || "development"
    config.root = Pathname.new(__dir__)
    # config.component_dirs.add 'repos'
    # config.component_dirs.add 'engine'
  end
end

class GameContainer
  extend Dry::Container::Mixin
  register(:rooms, Dry::Container.new)
  register(:items, Dry::Container.new)
  register(:npcs, Dry::Container.new)
end

App.register(:game, GameContainer)
App.register(:players, Concurrent::Hash.new)

Dir[App.config.root.join("boot", "**", "*.rb")].sort.each { |file| require file }
