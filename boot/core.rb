App.boot(:core) do
  start do
    use :zeitwerk

    GAME = Containers::Game
    ROOMS = Containers::Rooms
    ITEMS = Containers::Items
    NPCS = Containers::NPCS
    PLAYERS = Concurrent::Hash.new
  end
end

def Relative(path)
  Engine::Core.Relative(path, caller_locations.first.path)
end
