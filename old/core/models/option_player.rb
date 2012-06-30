module Models
  class OptionPlayer
    include DataMapper::Resource

    storage_names[:default] = 'options_players'

    property :id,     Serial
    property :value,  Text

    belongs_to :player, :key => true
    belongs_to :option, :key => true
  end
end