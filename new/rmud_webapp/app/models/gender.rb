class Gender < ActiveRecord::Base
  self.table_name = "gender"

  PL_MESKI_OS           = 1
  PL_MESKI_NOS_ZYW      = 2
  PL_MESKI_NOS_NZYW     = 3

  PL_ZENSKI             = 4

  PL_NIJAKI_OS          = 5
  PL_NIJAKI_NOS         = 6

  attr_accessible :name, :description

  def self.to_select_for_player
    Gender.where{id.in([PL_MESKI_OS, PL_ZENSKI])}
  end
end
