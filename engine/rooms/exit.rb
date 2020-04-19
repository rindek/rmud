# frozen_string_literal:
module Engine
  module Rooms
    class Exit
      extend Dry::Initializer

      option :name, type: Types::String
      option :to_id, type: Types::String
    end
  end
end
