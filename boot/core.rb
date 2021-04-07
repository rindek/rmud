# frozen_string_literal: true
def Room(input)
  called_from = caller_locations.first.path
  App[:game][:rooms].register(GameId(called_from), memoize: true) do
    Entities::Room.new(input.merge(id: GameId(called_from)))
  end
end

def Namespace(suffix)
  called_from = caller_locations.first.path
  Pathname(called_from).dirname.to_s.split("/").reject(&:empty?).then { |arr| arr.dup.push(suffix) }.join(".")
end

def GameId(file)
  Pathname(file).dirname.join(File.basename(file, File.extname(file))).to_s.split("/").reject(&:empty?).join(".")
end
