# frozen_string_literal: true
App.boot(:import) do
  start do
    use :zeitwerk

    class ImportContainer
      extend Dry::Container::Mixin

      namespace "repos" do
        register("rooms") { Repos::Rooms.new }
        register("players") { Repos::Players.new }
        register("dict") { Repos::Dict.new }
      end

      namespace "containers" do
        register("dictionary") { DICTIONARY }
      end

      namespace "lib" do
        register "shutdown" do
          Engine::Lib::Shutdown.new
        end
      end

      register("core") { Engine::Core }
    end

    Import = Dry.AutoInject(ImportContainer)
  end
end
