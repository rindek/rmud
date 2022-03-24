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
          to_filter_out = []

          player.slots[:left_hand].bind do
            to_filter_out << _1
            player.pwrite("W lewej ręce trzymasz #{_1.decorator(observer: player)}")
          end
          player.slots[:right_hand].bind do
            to_filter_out << _1
            player.pwrite("W prawej ręce trzymasz #{_1.decorator(observer: player)}")
          end

          message =
            Mudlib::Decorate.call(
              objects: player.inventory.items.without(to_filter_out),
              observer: player,
              when_empty: "Nie masz nic przy sobie",
            )

          Success(player.pwrite(message))
        end,
      )

      register(:spojrz) { |player:| Engine::Command::Game::Glance.new(player: player) }
      register(:wez) { |player:| Engine::Command::Game::Take.new(player: player) }
      register(:odloz) { |player:| Engine::Command::Game::Drop.new(player: player) }
      register(:dobadz) { |player:| Engine::Command::Game::Wield.new(player: player) }
      register(:opusc) { |player:| Engine::Command::Game::Unwield.new(player: player) }
    end
  end
end
