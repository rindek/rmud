# frozen_string_literal: true
module Engine
  module Commands
    class Game
      extend Dry::Container::Mixin
      extend Engine::Command::Game::Mixin

      register_command(
        :powiedz,
        ->(player, *args) do
          Engine::Events::Speak.call(who: player, what: args.join(" "), where: player.current_environment)
        end,
      )
      register_command(:zakoncz, ->(player, *args) { shutdown.call(player: player) }, ["lib.shutdown"])
      register_command(
        :clone,
        ->(player, *args) do
          Maybe(args[0])
            .or { Failure("What do you want to clone?\n") }
            .bind do |key|
              Try() { ITEMS.resolve(key) }
                .to_result
                .either(
                  ->(item) do
                    Engine::Actions::Move
                      .new
                      .call(object: item, dest: player)
                      .fmap do
                        player.write("%s cloned to your inventory.\n" % [item.decorator(observer: player).capitalize])
                      end
                      .or do |failure|
                        App[:logger].debug(failure)
                        Failure("Something went wrong, check logs.\n")
                      end
                  end,
                  ->(_) { Failure("Item to clone not found.\n") },
                )
            end
        end,
      )

      register_command(
        :i,
        ->(player, *args) do
          message =
            Mudlib::Decorate.call(
              objects: player.inventory.items,
              observer: player,
              when_empty: "Nie masz nic przy sobie",
            )

          Success(player.pwrite(message))
        end,
      )

      register(:spojrz) { |player:| Engine::Command::Game::Glance.new(player: player) }
    end
  end
end
