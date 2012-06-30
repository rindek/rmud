class Dictionary < ActiveRecord::Base
  set_table_name "dictionary"

  attr_accessible 
    :nominative, :genitive, :dative, :accusative, :instrumental, :locative,
    :plu_nominative, :plu_genitive, :plu_dative, :plu_accusative, :plu_instrumental, :plu_locative,
    :gender_id
end
