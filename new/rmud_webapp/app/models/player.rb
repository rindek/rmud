class Player < ActiveRecord::Base
  attr_accessible :name, :account_id, :dictionary_id
end
