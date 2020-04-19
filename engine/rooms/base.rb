# frozen_string_literal:
module Engine
  module Rooms
    class Base
      extend Dry::Initializer

      option :short, type: Types::String
      option :long, type: Types::String

      option :exits, type: Types::Array.of(Types.Instance(Engine::Rooms::Exit))
    end
  end
end
