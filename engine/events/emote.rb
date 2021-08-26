# frozen_string_literal: true
module Engine
  module Events
    class Emote < Base
      Schema =
        Dry::Schema.Params do
          required(:who).filled(Types.Interface(:present))
          required(:what).filled(Types::String)
          required(:where).filled(Types::Game::Environment)
        end

      def execute(who:, what:, where:)
        where
          .inventory
          .players(without: who)
          .each { |player| player.write("%s %s.\n" % [who.present.capitalize, what]) }

        Success()
      end
    end
  end
end
