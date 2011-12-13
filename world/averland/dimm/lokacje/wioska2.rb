# coding: utf-8
class current_namespace::Wioska2 < Std::Room
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

    add_exit('zachod', current_namespace::Wioska1)
    add_exit('startowa', World::Rooms::Room)
    add_exit('karczma', current_namespace::Karczma::Karczma)

  end

end