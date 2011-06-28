class Sql
  def connect
    db_config = read_config("database")
    game_config = read_config("game")

    connection_string = "DBI:Mysql:" + db_config[game_config['environment']]["database"] + ":" + db_config[game_config['environment']]["host"]

    DBI.connect(connection_string, db_config[game_config['environment']]["username"], db_config[game_config['environment']]["password"])
  end

  def disconnect
    DBI.disconnect_all('mysql')
  end

  def query(sql, *params)
    p sql
    p params

    connection = self.connect

    connection.prepare(sql) do |sth|
      sth.execute(*params)
    end

    connection.disconnect
  end

  def get(sql, *params)
    p sql
    p params

    result = []

    connection = self.connect

    connection.prepare(sql) do |sth|
      sth.execute(*params)

      while row = sth.fetch do
        result << row
      end
    end

    connection.disconnect

    result
  end

  def one(sql, *params)
    p sql
    p params

    row = nil
    connection = self.connect

    connection.prepare(sql) do |sth|
      sth.execute(*params)
      row = sth.fetch
    end

    connection.disconnect

    row
  end

  def insert(table, params)
    sql = "insert into " + table

    sql += " ( "
    sql += params.keys.collect {|x| "`" + x.to_s + "`"}.join(", ")
    sql += " ) "

    sql += " values "

    sql += " ( "
    sql += ("?" * params.keys.size).split("").join(", ")
    sql += " ) "

    self.query(sql, *params.values)
  end

  def update(table, params, id, id_column = "id")
    sql = "update " + table
    sql += " set "

    sql += params.collect {|k, v| "`" + k.to_s + "` = ?"}.join(", ")
    sql += " WHERE " + id_column + " = " + id.to_i.to_s

    self.query(sql, *params.values)
  end
end
