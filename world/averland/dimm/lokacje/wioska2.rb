# coding: utf-8
class Wioska2 < Std::Room
  include Singleton

  def initialize
    super()

    @short = "Przed karczma"

    @long = "Znajdujesz sie na ulicy, przechodzacej przez wioske Tadrig. " 
    @long << "Tuz przed toba stoi duzy budynek z pieknie wykonanym szyldem. " 
    @long << "Z drugiej strony drogi znajduje sie zwykla chata, nalezaca do " 
    @long << "jakiegos wiesniaka. Ulica ciagnie sie ku wyjsciu z wioski na " 
    @long << "zachod, oraz glebiej w strone jedynego dwupietrowego budynku na wschodzie. "
    @long << " Zauwazasz niestarannie wbita w ziemie mala "
    @long << "drewniana tabliczke."    

    add_exit('zachod', Wioska1)
    add_exit('startowa', World::Rooms::Room)
    add_exit('karczma', Karczma::Karczma)

  end

end