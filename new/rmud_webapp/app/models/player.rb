class Player < ActiveRecord::Base
  attr_accessible :name, :account_id, :dictionary_id

  validates_presence_of :name
  validates_uniqueness_of :name

  belongs_to :account
  belongs_to :dictionary
end
