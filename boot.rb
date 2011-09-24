## ruby 1.9.2 required
require 'rbconfig'
unless RbConfig::CONFIG['ruby_version'] >= "1.9.1"
  puts "Ruby version 1.9.2 or higher is required to run the program"
  Process.exit
end

begin
  require 'bundler' unless defined?(Bundler)
rescue LoadError
  raise "Could not load the bundler gem. Install it with 'gem install bundler'"
end

begin
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound => e
  puts e.message
  puts "Bundler couldn't find some gems. Did you run 'bundle install'?"
  Process.exit
end

Bundler.require
