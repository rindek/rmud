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

# # frozen_string_literal: true
# def Room(input)
#   called_from = caller_locations.first.path
#   id = input[:id] || GameId(called_from)
#   ROOMS.register(id, memoize: true) do
#     Entities::Game::Room
#       .new(input.merge(id: id))
#       .tap { |room| Dry::Monads.Maybe(room.callbacks[:after_load]).bind { |callback| callback.call(room) } }
#   end
# end

# def Item(input)
#   called_from = caller_locations.first.path
#   id = input[:id] || GameId(called_from)
#   ITEMS.register(id, memoize: false) { Entities::Game::Item.new(input.merge(id: id)) }
# end

# def NPC(input)
#   called_from = caller_locations.first.path
#   id = input[:id] || GameId(called_from)
#   NPCS.register(id, memoize: false) { Entities::Game::Creature.new(input.merge(id: id)) }
# end

def Namespace(suffix)
  called_from = caller_locations.first.path[4..]

  # binding.pry
  Pathname(called_from).dirname.to_s.split("/").reject(&:empty?).then { |arr| arr.dup.push(suffix) }.join(".")
end

# def GameId(file)
#   Pathname(file[11..]).dirname.join(File.basename(file, File.extname(file))).to_s.split("/").reject(&:empty?).join(".")
# end
