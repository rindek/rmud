module Mudlib
  class Writer < Engine::Lib::Abstract
    def call(object:, player:)
      binding.pry

      case
      when String === object
        object
      when Types::Array.of(Types::Game::GameObject).try(Array(object)).success? == true
        Array(object).map { |obj| obj.decorator(observer: player) }.join(", ").capitalize + ".\n"
      else
        "Error while sending message. Unknown type #{msg.inspect}\n"
      end
    end
  end
end
