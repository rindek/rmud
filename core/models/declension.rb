module Models
  class Declension
    include DataMapper::Resource

    storage_names[:default] = 'declension'

    property :nazwa,        String, :key => true, :unique => true, :length => 150
    property :mianownik,    String, :length => 150
    property :dopelniacz,   String, :length => 150
    property :celownik,     String, :length => 150
    property :biernik,      String, :length => 150
    property :narzednik,    String, :length => 150
    property :miejscownik,  String, :length => 150
    property :rodzaj,       Integer, :min => 0

    def show_declension
      declension = ""
      declension += "Mianownik: " + self.mianownik + "\n"
      declension += "Dopelniacz: " + self.dopelniacz + "\n"
      declension += "Celownik: " + self.celownik + "\n"
      declension += "Biernik: " + self.biernik + "\n"
      declension += "Narzednik: " + self.narzednik + "\n"
      declension += "Miejscownik: " + self.miejscownik + "\n"

      declension
    end
  end
end
