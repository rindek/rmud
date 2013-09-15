## ruby 2.0.0 required
unless RUBY_VERSION >= "2.0.0"
  puts "Ruby version 2.0.0 or higher is required to run the program"
  Process.exit
end

require './boot/environment'
require './boot/bundler'
require './boot/connector'

Dir.glob(Rmud.root + "/boot/initializers/*.rb").each {|f| require f}
