# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Wield < Base
        def call(*args)
          to_find = args.join(" ")

          weapon = player.inventory.weapons.find { _1.match?(to_find) }

          return Failure("Dobądź <co>?\n") unless weapon

          yield (
            case Engine::Actions::Wield.call(weapon: weapon, player: player)
            in Failure[:need_both_hands_empty]
              Failure("Potrzebujesz obu wolnych rąk by dobyć #{weapon.decorator(observer: player)}.\n")
            in Failure[:need_one_hand_empty]
              Failure("Potrzebujesz jednej wolnej ręki by dobyć #{weapon.decorator(observer: player)}.\n")
            in Failure[:already_wielding]
              Failure("Już dobywasz tej broni.\n")
            else
              Success()
            end
          )

          client.pwrite("Dobywasz #{weapon.decorator(observer: player)}")
          Success()
        end
      end
    end
  end
end
