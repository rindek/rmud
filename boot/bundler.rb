begin
  require 'bundler' unless defined?(Bundler)
rescue LoadError
  raise "Could not load the bundler gem. Install it with 'gem install bundler'"
end

begin
  ENV["BUNDLE_GEMFILE"] = "#{Rmud.root}/Gemfile"
  Bundler.setup
rescue Bundler::GemNotFound => e
  puts e.message
  puts "Bundler couldn't find some gems. Did you run 'bundle install'?"
  Process.exit
end
Bundler.require
