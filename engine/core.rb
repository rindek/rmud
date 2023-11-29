module Engine
  class Core
    include Dry::Monads[:try, :result]
    include Import["repos.rooms", "repos.items", "repos.weapons", "repos.npcs"]

    def Room(input)
      id = input[:id] || GameID(caller_locations.first.path)
      rooms.create(id: id, input: input, cache: true) do |room|
        Dry::Monads.Maybe(room.callbacks[:after_load]).bind { |callback| callback.call(room) }
      end
    end

    def Item(input)
      id = input[:id] || GameID(caller_locations.first.path)
      items.create(id: id, input: input, cache: false)
    end

    def Weapon(input)
      id = input[:id] || GameID(caller_locations.first.path)
      weapons.create(id: id, input: input, cache: false)
    end

    def NPC(input)
      id = input[:id] || GameID(caller_locations.first.path)
      npcs.create(id: id, input: input, cache: false) do |npc|
        Dry::Monads.Maybe(npc.callbacks[:after_clone]).bind { |callback| callback.call(npc) }
      end
    end

    def GameID(file)
      Pathname(file[4..])
        .dirname
        .join(File.basename(file, File.extname(file)))
        .to_s
        .split("/")
        .reject(&:empty?)
        .join(".")
    end

    def Relative(path, from = caller_locations.first.path)
      Pathname(from[4..]).dirname.join(path).to_s.gsub(%r{\/}, ".")[1..]
    end

    def weapon?(item)
      Entities::Game::Weapon === item
    end
  end
end
