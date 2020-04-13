# frozen_string_literal: true
module Engine
  module Handlers
    class Login
      extend Dry::Initializer

      param :client, type: Types.Instance(Engine::Client)

      def receive(message)
        # binding.pry
      end
    end
  end
end
