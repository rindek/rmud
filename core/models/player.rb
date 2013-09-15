module Models
  class Player
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: "players"

    field :name, type: String
    belongs_to :account
    has_one :entry, autobuild: true

    attr_accessible :name, :entry_attributes

    validates_presence_of :name, :entry, :account
    validates_uniqueness_of :name

    accepts_nested_attributes_for :entry
  end
end
