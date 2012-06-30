module Models
  class Banish
    include DataMapper::Resource

    storage_names[:default] = 'banishes'

    property :id,       Serial
    property :name,     String
    property :reason,   Text
    belongs_to :banished_by, 'Player', :key => false, :required => false

    timestamps :created_at
  end
end
