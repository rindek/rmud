module Models
  class Player < Models::Model

    def initialize
      super

      @table_name = "players"
    end

    def get_by_name(name)
      query = "select * from players where name = ?"
      @sql.one(query, name)
    end

    def get_option(player_id, option_name)
      query = "select value from players_options
      left join options on (players_options.option_id = options.id)
      where players_options.player_id = ? AND options.name = ? LIMIT 1"
      @sql.one(query, player_id, option_name)
    end
  end
end
