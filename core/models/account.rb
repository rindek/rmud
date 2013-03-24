# module Models
#   class Account
#     include DataMapper::Resource

#     storage_names[:default] = 'accounts'

#     property :id,       Serial
#     property :name,     String
#     property :email,    String
#     property :password, Text
#     property :player_password, Text

#     has n, :players

#     def get_by_name(name)
#       Models::Account.first(:name => name)
#     end

# #    def initialize
# #      super
# #
# #      @table_name = "accounts"
# #    end
# #
# #    def get_by_name(name)
# #      query = "select * from accounts where name = ?"
# #      @sql.one(query, name)
# #    end
# #
# #    def get_players(id)
# #      query = "select * from players where account_id = ?"
# #      @sql.get(query, id)
# #    end
# #
# #    def get_by_player_id(id)
# #      query = "select * from accounts where id = (select account_id from players where id = ?)"
# #      @sql.one(query, id)
# #    end
#   end
# end
