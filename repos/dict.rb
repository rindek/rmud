# frozen_string_literal: true
module Repos
  class Dict < Local
    option :dataset, default: -> { App[:mongo][:dictionary] }
    option :entity, default: -> { Entities::DB::Dict }

    def find(name)
      find_by(nazwa: name)
    end

    def create_entry(name, singular, plural, type)
      type_check = Types::Array.of(Types::String).constrained(size: 7)
      yield (
        Try() do
          type_check[singular]
          type_check[plural]
        end
      )

      data = {
        nazwa: name,
        pojedyncza: {
          mianownik: singular[0],
          dopelniacz: singular[1],
          celownik: singular[2],
          biernik: singular[3],
          narzednik: singular[4],
          miejscownik: singular[5],
          wolacz: singular[6],
        },
        mnoga: {
          mianownik: plural[0],
          dopelniacz: plural[1],
          celownik: plural[2],
          biernik: plural[3],
          narzednik: plural[4],
          miejscownik: plural[5],
          wolacz: plural[6],
        },
        rodzaj: type,
      }

      insert(data)
    end
  end
end
