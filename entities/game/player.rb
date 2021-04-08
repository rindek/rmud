# frozen_string_literal: true
module Entities
  module Game
    class Player < Creature
      attribute :data, Types::DB::Player
      attribute :client, Types.Instance(Engine::Client)

      delegate :write, to: :client
      delegate :name, to: :data
    end
  end
end
