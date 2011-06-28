module Declension
  attr_reader :declination

	def init_declension
		@declination = {
			:mia => nil, :dop => nil, :cel => nil, :bie => nil, :nar => nil, :mie => nil
		}
	end

  def mia= (mia)
		puts @declination
    @declination[:mia] = mia
  end

  def dop= (dop)
    @declination[:dop] = dop
  end

  def cel= (cel)
    @declination[:cel] = cel
  end

  def bie= (bie)
    @declination[:bie] = bie
  end

  def nar= (nar)
    @declination[:nar] = nar
  end

  def mie= (mie)
    @declination[:mie] = mie
  end

	def decline
    declination = ""
    declination += "Mianownik: " + @declination[:mia] + "\n"
    declination += "Dopelniacz: " + @declination[:dop] + "\n"
    declination += "Celownik: " + @declination[:cel] + "\n"
    declination += "Biernik: " + @declination[:bie] + "\n"
    declination += "Narzednik: " + @declination[:nar] + "\n"
    declination += "Miejscownik: " + @declination[:mia] + "\n"

    declination
  end

	def set_declination(mia, dop, cel, bie, nar, mie)
		mia = mia
		dop = dop
		cel = cel
		bie = bie
		nar = nar
		mie = mie
	end
end
