# frozen_string_literal: true
module Entities
  module Game
    class Player < MovableObject
      include Traits::Inventory

      attribute :data, Types::DB::Player
      attribute :client, Types.Instance(Engine::Client)

      delegate :write, :pwrite, to: :client
      delegate :name, to: :data

      def slots
        @slots ||=
          {
            head: None(),
            torso: None(),
            legs: None(),
            neck: None(),
            left_finger: None(),
            right_finger: None(),
            feet: None(),
            left_hand: None(),
            right_hand: None(),
          }
      end

      def decorator(observer:)
        name.capitalize
      end

      def replace_client(new_client)
        client.write("Ta sesja zostala przejęta - zamykam to połączenie.\n")
        client.close
        attributes[:client] = new_client
      end

      def dump_info
        { name: self.name, environment: self.current_environment.dump_info }
      end
    end
  end
end
