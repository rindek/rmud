# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Unwield < Base
        def call(*args)
          to_find = args.join(" ")

          weapon =
            [player.slots[:right_hand], player.slots[:left_hand]].find do
                case _1
                in Some[w]
                  w.match?(to_find)
                in None
                  false
                end
              end
              .then(&method(:Maybe))
              .then(&:flatten)

          case weapon
          in Some[w]
            yield Engine::Actions::Unwield.call(weapon: w, player: player)

            client.pwrite("Opuszczasz #{w.decorator(observer: player)}")

            Success()
          in None
            Failure("Opuść <co>?\n")
          end
        end
      end
    end
  end
end
