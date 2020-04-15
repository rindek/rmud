require "bundler"
Bundler.require

require "./database"

loader = Zeitwerk::Loader.for_gem
loader.log!
loader.ignore("./spec")
loader.setup
# loader.eager_load

module Types
  include Dry.Types()
end
