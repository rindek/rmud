module Engine
  module Core
    module_function

    def Room(input)
      called_from = caller_locations.first.path
      id = input[:id] || GameID(called_from)
      ROOMS.register(id, memoize: true) do
        Entities::Game::Room
          .new(input.merge(id: id))
          .tap { |room| Dry::Monads.Maybe(room.callbacks[:after_load]).bind { |callback| callback.call(room) } }
      end
    end

    def Item(input)
      called_from = caller_locations.first.path
      id = input[:id] || GameID(called_from)
      ITEMS.register(id, memoize: false) { Entities::Game::Item.new(input.merge(id: id)) }
    end

    def NPC(input)
      called_from = caller_locations.first.path
      id = input[:id] || GameID(called_from)
      NPCS.register(id, memoize: false) { Entities::Game::Creature.new(input.merge(id: id)) }
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
  end
end
