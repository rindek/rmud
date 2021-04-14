# frozen_string_literal: true
module Engine
  module Events
    class Speak < Base
      Schema =
        Dry::Schema.Params do
          required(:who).filled(Types::Game::Player)
          required(:what).filled(Types::String)
          required(:where).filled(Types::Game::Environment)
          optional(:to_whom).maybe(Types::Game::Player)
        end

      def execute(who:, what:, where:, to_whom: nil)
        where.inventory.players(without: who).each { |player| player.write("%s mowi: %s\n" % [who.name, what]) }
        who.write("Mowisz: %s\n" % [what])

        Success()
      end
    end
  end
end
