# frozen_string_literal: true
module State
  class Player
    extend Dry::Monads[:result, :maybe]

    def self.get(name)
      Maybe(App[:redis].get(name)).to_result.bind do |data|
        Some(Entities::Player.new(Hash.from_bson(BSON::ByteBuffer.new(data))))
      end.or do
        Repos::Players
          .new
          .find_by(name: name)
          .bind do |entity|
            App[:redis].set(name, entity.to_h.to_bson)
            Some(entity)
          end
      end
    end

    def self.clear(name)
      App[:redis].del(name)
      Success()
    end
  end
end
