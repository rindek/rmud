# frozen_string_literal: true
module Engine
  class Player
    extend Dry::Initializer

    option :client, type: Types.Instance(Engine::Client)

    delegate :close, :write, to: :client
  end
end
