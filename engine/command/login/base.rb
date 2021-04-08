# frozen_string_literal: true
module Engine
  module Command
    module Login
      class Base
        extend Dry::Initializer
        include Dry::Monads[:result, :do, :maybe]

        option :client, type: Types.Instance(Engine::Client)
        option :tp, type: Types::Game::Player, optional: true
      end
    end
  end
end
