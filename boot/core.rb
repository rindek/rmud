App.boot(:core) do
  init { use :import }

  start do
    GAME = Containers::Game
    ROOMS = Containers::Rooms
    ITEMS = Containers::Items
    WEAPONS = Containers::Weapons
    NPCS = Containers::NPCS
    PLAYERS = Concurrent::Hash.new
    DICTIONARY = Containers::Dictionary

    CORE = Engine::Core.new
  end
end

def Relative(path)
  CORE.Relative(path, caller_locations.first.path)
end
