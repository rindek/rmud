module Models
  class Model
    def initialize
      @sql = Sql.new
      @table_name = nil
    end

    def by_id(id)
      query = "select * from " + @table_name + " where id = ?"
      @sql.one(query, id)
    end

    def save(id, params)
      if id == 0
        @sql.insert(@table_name, params)
      else
        @sql.update(@table_name, params, id)
      end
    end
  end
end