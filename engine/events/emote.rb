# frozen_string_literal: true
module Engine
  module Events
    class Emote < Base
      Schema =
        Dry::Schema.Params do
          required(:who).filled(Types.Interface(:observer))
          required(:what).filled(Types::String)
          required(:where).filled(Types::Game::Environment)
        end

      def execute(who:, what:, where:)
        where
          .inventory
          .players(without: who)
          .each { |player| player.pwrite("%s %s" % [who.decorator(observer: player), what]) }

        Success()
      end
    end
  end
end
