module Mudlib
  class Decorate < Engine::Lib::Abstract
    def call(objects:, observer:)
      case
      when Types::Array.of(Types::Game::GameObject).try(Array(objects)).success? == true
        Array(objects).map { |obj| obj.decorator(observer: observer) }.join(", ")
      else
        "Error while sending message. Unknown type #{objects.inspect}\n"
      end
    end
  end
end
