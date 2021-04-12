# frozen_string_literal: true
module Entities
  module Game
    class Player < Creature
      attribute :data, Types::DB::Player
      attribute :client, Types.Instance(Engine::Client)

      delegate :write, to: :client
      delegate :name, to: :data

      def replace_client(new_client)
        attributes[:client] = new_client
        client.write("Ta sesja zostala przejęta - zamykam to połączenie.\n")
        client.close
      end
    end
  end
end
