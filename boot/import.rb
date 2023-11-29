# frozen_string_literal: true
App.boot(:import) do
  init { use :zeitwerk }
  start do
    class ImportContainer
      extend Dry::Container::Mixin

      namespace "repos" do
        register("dict") { Repos::Dict.new }
        register("items") { Repos::Items.new }
        register("npcs") { Repos::Npcs.new }
        register("players") { Repos::Players.new }
        register("rooms") { Repos::Rooms.new }
        register("weapons") { Repos::Weapons.new }
      end

      namespace "containers" do
        register("dictionary") { DICTIONARY }
      end

      namespace "lib" do
        register "shutdown" do
          Engine::Lib::Shutdown.new
        end
      end
    end

    Import = Dry.AutoInject(ImportContainer)
  end
end
