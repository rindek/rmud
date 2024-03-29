module Engine
  module Core
    include Dry::Monads[:try]
    extend Dry::Monads[:result]

    module_function

    def Room(input)
      id = input[:id] || GameID(caller_locations.first.path)
      ROOMS.register(id, memoize: true) do
        Entities::Game::Room
          .new(input.merge(id: id))
          .tap { |room| Dry::Monads.Maybe(room.callbacks[:after_load]).bind { |callback| callback.call(room) } }
      end
    end

    def Item(input)
      id = input[:id] || GameID(caller_locations.first.path)
      ITEMS.register(id, memoize: false) { Entities::Game::Item.new(input.merge(id: id)) }
    end

    def Weapon(input)
      id = input[:id] || GameID(caller_locations.first.path)
      WEAPONS.register(id, memoize: false) { Entities::Game::Weapon.new(input.merge(id: id)) }
    end

    def NPC(input)
      id = input[:id] || GameID(caller_locations.first.path)
      NPCS.register(id, memoize: false) do
        Entities::Game::Creature
          .new(input.merge(id: id))
          .tap { |npc| Dry::Monads.Maybe(npc.callbacks[:after_clone]).bind { |callback| callback.call(npc) } }
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
