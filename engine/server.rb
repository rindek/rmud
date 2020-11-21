# frozen_string_literal: true
module Engine
  module Server
    delegate :receive_data, to: :@client

    def post_init
      puts "-- new connection --"
      @client = Engine::Client.new(em_connection: self)
    end

    def unbind
      puts "-- disconnect --"
    end
  end
end
