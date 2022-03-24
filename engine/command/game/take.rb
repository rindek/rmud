# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Take < Base
        def call(*args)
          to_find = args.join(" ")

          items = player.current_environment.inventory.items
          item = items.find { |item| item.match?(to_find) }

          return Failure("Weź <co>?\n") unless item

          yield Engine::Actions::Move.call(object: item, dest: player)

          client.pwrite("Bierzesz #{item.decorator(observer: player)}")
          Success()
        end
      end
    end
  end
end
