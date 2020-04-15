# frozen_string_literal: true
module Engine
  module Command
    class Base
      extend Dry::Initializer

      param :tp, type: Types.Instance(Engine::Player)
    end
  end
end
