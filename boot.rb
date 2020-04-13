require "bundler"
Bundler.require

loader = Zeitwerk::Loader.for_gem
loader.log!
loader.ignore("./spec")
loader.setup
# loader.eager_load
