class PlayerConnectionLib
  attr_accessor :input_handler
  
  def initialize(connection)
    @connection = connection
  end
  
  def print(data)
    @connection.send_data(data)
  end
  
  def println(data)
    @connection.send_data("#{data}\n")
  end
  
  def disconnect
    @connection.close_connection_after_writing
  end
end
