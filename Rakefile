require "sequel/rake"
Sequel::Rake.load!

require "./database"
Sequel::Rake.configure { set :connection, DB }

task :environment do
  require_relative "./boot"
end

Dir[File.join(".", "tasks", "**", "*.rake")].sort.each { |file| load file }
