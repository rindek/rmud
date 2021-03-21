require "sequel/rake"
Sequel::Rake.load!

require "./boot"
Sequel::Rake.configure { set :connection, App.start(:persistence)[:database] }

task :environment do
  App.start(:requirements)
  App.start(:rooms)
end

Dir[File.join(".", "tasks", "**", "*.rake")].sort.each { |file| load file }
