# module Models
#   class Option
#     include DataMapper::Resource

#     storage_names[:default] = 'options'

#     property :id,       Serial
#     property :name,     String, :length => 255
#     property :active,   Boolean

#     has n, :players, :through => :option_players
#   end
# end
