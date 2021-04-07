# frozen_string_literal: true
module Engine
  module Command
    class Powiedz < Base
      def call(*arg)
        to_say = arg.join(" ")
        client.write("Mowisz: #{to_say}\n")

        players =
          tp.current_environment.inventory.items.select { |item| item.is_a?(Entities::Player) }.reject do |item|
            item == tp
          end
        players.each { |player| PLAYERS[player.name][:client].write("#{tp.presentable} mowi: #{to_say}\n") }

        Success(true)
      end
    end
  end
end
