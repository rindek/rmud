require "./boot"

task :environment do
  App.start(:requirements)
  App.start(:rooms)
end

Dir[File.join(".", "tasks", "**", "*.rake")].sort.each { |file| load file }
