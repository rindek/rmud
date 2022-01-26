# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Unwield < Base
        def call(*args)
          to_find = args.join(" ")

          weapon =
            player.slots[:right_hand]
              .bind { _1.match?(to_find) ? Some(_1) : None() }
              .or { player.slots[:left_hand].bind { _1.match?(to_find) ? Some(_1) : None() } }

          return Failure("Opuść <co>?\n") if weapon.none?

          yield Engine::Actions::Unwield.call(weapon: weapon.value!, player: player)

          client.pwrite("Opuszczasz #{weapon.value!.decorator(observer: player)}")
          Success()
        end
      end
    end
  end
end
