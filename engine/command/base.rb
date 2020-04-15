# frozen_string_literal: true
module Engine
  module Command
    class Base
      extend Dry::Initializer
      include Dry::Monads[:result, :do, :maybe]

      param :tp, type: Types.Instance(Engine::Player)
    end
  end
end
