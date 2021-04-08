# frozen_string_literal: true
module Engine
  module Command
    module Game
      class Base
        extend Dry::Initializer
        include Dry::Monads[:result, :do, :maybe]

        option :player, type: Types::Game::Player

        delegate :client, to: :player
        delegate :tp, to: :player
      end
    end
  end
end
