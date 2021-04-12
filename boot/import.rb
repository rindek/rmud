# frozen_string_literal: true
App.boot(:import) do
  start do
    use :zeitwerk

    class ImportContainer
      extend Dry::Container::Mixin

      namespace "repos" do
        register "rooms" do
          Repos::Rooms.new
        end

        register "room_exits" do
          Repos::RoomExits.new
        end

        register "players" do
          Repos::Players.new
        end
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
