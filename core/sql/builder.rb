module SQL
  class Builder
    def initialize()
      @select_string = nil
      @where = []
      @joins = []
      @orderby = []
      @groupby = []
      @table_name = nil
      @select_string = nil
      @limit = nil
    end


    def select(var, table_name)
      @select_string = "SELECT "+ var +" FROM "+ table_name
      return self
    end

    def where(string, condition, operator = "=")
      if @where.size > 0
        @where << "AND ("+ string +") "+ operator +" "+ condition
      else
        @where << "("+ string +") "+ operator +" "+ condition
      end

      return self
    end

    def build
      sql = @select_string +" "

      if @where.size > 0
        sql += " WHERE "+ @where.join(" ")
      end

      return sql
    end
  end
end