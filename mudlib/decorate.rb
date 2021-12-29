module Mudlib
  class Decorate < Engine::Lib::Abstract
    def call(objects:, observer:, when_empty: "Pusto")
      return when_empty if Array(objects).empty?

      case
      when Types::Array.of(Types::Game::GameObject).try(Array(objects)).success?
        Array(objects).map { |obj| obj.decorator(observer: observer) }.join(", ")
      else
        "Error while sending message. Unknown type #{objects.inspect}\n"
      end
    end
  end
end
