class NextHandler < BaseHandler
  def initialize(player_connection, next_handler)
    @next_handler = next_handler
    @player_connection = player_connection
  end

  def input(data)
    @player_connection.input_handler = @next_handler.new(@player_connection)
  end
end