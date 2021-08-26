# frozen_string_literal: true
module Entities
  module Game
    class Player < MovableObject
      include Traits::Inventory

      attribute :data, Types::DB::Player
      attribute :client, Types.Instance(Engine::Client)

      delegate :write, to: :client
      delegate :name, to: :data

      def present
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
