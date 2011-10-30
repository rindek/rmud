class NextHandler < BaseHandler
  def initialize(player_connection, next_handler)
    @next_handler = next_handler
    @player_connection = player_connection
  end

  def input(data)
    if @next_handler.is_a?(Class)
      @player_connection.input_handler = @next_handler.new(@player_connection)
    else
      @player_connection.input_handler = @next_handler
    end
  end
end