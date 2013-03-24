class DeclensionNotFoundException < Exception; end

module Modules
  module Declension
    attr_accessor :declension_entry

    def set_declension entry
      
      if entry.is_a? String
        self.declension_entry = Models::Entry.find_by(mianownik: entry)
        raise DeclensionNotFoundException, entry if self.declension_entry.nil?
      else
        self.declension_entry = entry
      end
    end

    def mianownik
      self.declension_entry.mianownik
    end

    def dopelniacz
      self.declension_entry.dopelniacz
    end

    def celownik
      self.declension_entry.celownik
    end

    def biernik
      self.declension_entry.biernik
    end

    def narzednik
      self.declension_entry.narzednik
    end

    def miejscownik
      self.declension_entry.miejscownik
    end

    def rodzaj
      self.declension_entry.rodzaj
    end

    def declension(przypadek)
      self.declension_entry.send(przypadek)
    end

  end
end
