require "./boot"

task :environment do
  App.start(:requirements)
end

Dir[File.join(".", "tasks", "**", "*.rake")].sort.each { |file| load file }
