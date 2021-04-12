# frozen_string_literal: true
module Engine
  module Server
    delegate :receive_data, to: :@client

    def close_connection(*args)
      @intentionally_closed_connection = true
      super(*args)
    end

    def post_init
      @intentionally_closed_connection = false
      @client = Engine::Client.new(em_connection: self)
      puts "---- new connection ----"
    end

    def unbind
      puts "-- disconnect (intentionally? #{@intentionally_closed_connection}) --"
      return if @intentionally_closed_connection
      @client.current_player.bind { |player| Engine::Lib::Shutdown.new.call(player: player) }
    end
  end
end
