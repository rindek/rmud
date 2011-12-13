# coding: utf-8
class current_namespace::Wioska1 < Std::Room
  include Singleton

  def initialize
    super()

    @short = "Przy wejsciu do wioski"

    @long = "Znajdujesz sie przy wejsciu do nieduzej wioski, podobnej do wielu innych wiosek "
    @long << "w tych okolicach. Droga zmienia sie tu "
    @long << "w blotnista wioskowa ulice. Na polnocnym wschodzie stad widzisz duzy budynek z "
    @long << "ledwo widocznym szyldem, dalej na wschod droga prowadzi przez wioske w "
    @long << "kierunku najwyzszego budynku. Przy drodze stoi slup z nazwa wioski. "    

    # add_exit('zachod', DIMM_PATH_LOKACJE::Droga5)
    add_exit('wschod', current_namespace::Wioska2)

  end

end