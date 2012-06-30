class Gender < ActiveRecord::Base
  set_table_name "gender"

  attr_accessible :name, :description
end
