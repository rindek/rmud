require "dry/system/container"

class App < Dry::System::Container
  use :env

  configure do |config|
    config.env = ENV["STAGE"] || "development"
    config.root = Pathname.new(__dir__)
  end
end

Dir[App.config.root.join("boot", "**", "*.rb")].sort.each { |file| require file }
