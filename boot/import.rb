# frozen_string_literal: true
App.boot(:import) do
  start do
    use :zeitwerk

    class ImportContainer
      extend Dry::Container::Mixin

      namespace "repos" do
        register "room" do
          Repos::Room.new
        end

        register "room_exit" do
          Repos::RoomExit.new
        end

        register "player" do
          Repos::Player.new
        end
      end
    end

    Import = Dry.AutoInject(ImportContainer)
  end
end
