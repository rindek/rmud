# declension entry
module Models
  class Entry
    include Mongoid::Document

    store_in collection: "entries"

    belongs_to :player, inverse_of: nil

    PLAYER_TYPES = {"meski" => :mo, "zenski" => :z}

    field :mianownik, type: String
    field :dopelniacz, type: String
    field :celownik, type: String
    field :biernik, type: String
    field :narzednik, type: String
    field :miejscownik, type: String
    field :rodzaj, type: Symbol

    field :mmianownik, type: String
    field :mdopelniacz, type: String
    field :mcelownik, type: String
    field :mbiernik, type: String
    field :mnarzednik, type: String
    field :mmiejscownik, type: String

    validates_presence_of :mianownik, :dopelniacz, :celownik, :biernik, :narzednik, :miejscownik, :rodzaj
    validates_inclusion_of :rodzaj, in: [:mo, :mnz, :mnn, :z, :no, :nn]

    attr_accessible :mianownik, :dopelniacz, :celownik, :biernik, :narzednik, :miejscownik, :rodzaj,
                    :mmianownik, :mdopelniacz, :mcelownik, :mbiernik, :mnarzednik, :mmiejscownik
  end
end
