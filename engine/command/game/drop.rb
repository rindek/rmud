# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Drop < Base
        def call(*args)
          to_find = args.join(" ")

          items = player.inventory.items
          item = items.find { |item| item.match?(to_find) }

          return Failure("Odłóż <co>?\n") unless item

          yield Engine::Actions::Move.call(object: item, dest: player.current_environment)

          client.pwrite("Odkładasz #{item.decorator(observer: player)}")
          Success()
        end
      end
    end
  end
end
