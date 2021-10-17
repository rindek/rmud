App.boot(:core) do
  start do
    use :zeitwerk

    GAME = Containers::Game
    ROOMS = Containers::Rooms
    ITEMS = Containers::Items
    NPCS = Containers::NPCS
    PLAYERS = Concurrent::Hash.new

    def Namespace(suffix)
      raise "replace me with Relative in #{caller_locations.first.path}"
    end
  end
end

def Relative(path)
  Engine::Core.Relative(path)
end
