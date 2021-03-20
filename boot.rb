require "dry/system/container"

class App < Dry::System::Container
  use(:env)
  configure { config.root = Pathname.new(__dir__) }
end

Dir[File.join(".", "boot", "**", "*.rb")].sort.each { |file| require file }

App.start(:requirements)

PLAYERS = {}
