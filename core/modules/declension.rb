class DeclensionNotFoundException < Exception; end
class DeclensionWrongDataException < Exception; end

module Modules
  module Declension
    attr_reader :declination

    def set_declension dec
      @declension = {
        mianownik: '',
        dopelniacz: '',
        celownik: '',
        biernik: '',
        narzednik: '',
        miejscownik: '',
        rodzaj: ''
      }
      
    end

    def mianownik
      @declension[:mianownik]
    end

    def dopelniacz
      @declension[:dopelniacz]
    end

    def celownik
      @declension[:celownik]
    end

    def biernik
      @declension[:biernik]
    end

    def narzednik
      @declension[:narzednik]
    end

    def miejscownik
      @declension[:miejscownik]
    end

    def rodzaj
      @declension[:rodzaj]
    end

    def declension(przypadek)
      @declension[przypadek]
    end

  end
end
