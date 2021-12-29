# frozen_string_literal: true
module Entities
  module DB
    class Dict < Base
      attribute :pojedyncza do
        attribute :mianownik, Types::String
        attribute :dopelniacz, Types::String
        attribute :celownik, Types::String
        attribute :biernik, Types::String
        attribute :narzednik, Types::String
        attribute :miejscownik, Types::String
        attribute :wolacz, Types::String
      end

      attribute :mnoga do
        attribute :mianownik, Types::String
        attribute :dopelniacz, Types::String
        attribute :celownik, Types::String
        attribute :biernik, Types::String
        attribute :narzednik, Types::String
        attribute :miejscownik, Types::String
        attribute :wolacz, Types::String
      end

      attribute :rodzaj, Types::String.enum("mesko-osobowy", "mesko-zywotny", "mesko-niezywotny", "zenski", "nijaki")
    end
  end
end
