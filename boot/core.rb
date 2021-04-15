# frozen_string_literal: true
def Room(input)
  called_from = caller_locations.first.path
  id = input[:id] || GameId(called_from)
  App[:game][:rooms].register(id, memoize: true) do
    Entities::Game::Room
      .new(input.merge(id: id))
      .tap { |room| Dry::Monads.Maybe(room.callbacks[:after_load]).bind { |callback| callback.call } }
  end
end

def Item(input)
  called_from = caller_locations.first.path
  id = input[:id] || GameId(called_from)
  App[:game][:items].register(id, memoize: false) { Entities::Game::Item.new(input.merge(id: id)) }
end

def Namespace(suffix)
  called_from = caller_locations.first.path
  Pathname(called_from).dirname.to_s.split("/").reject(&:empty?).then { |arr| arr.dup.push(suffix) }.join(".")
end

def GameId(file)
  Pathname(file).dirname.join(File.basename(file, File.extname(file))).to_s.split("/").reject(&:empty?).join(".")
end
