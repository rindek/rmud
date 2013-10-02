class PlayerConnectionLib
  attr_accessor :input_handler
  
  def initialize(connection, handler)
    @connection = connection
    self.input_handler = handler.new player: self
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
