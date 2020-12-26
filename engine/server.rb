# frozen_string_literal: true
module Engine
  module Server
    extend Forwardable

    # delegate :receive_data, to: :@client
    def_delegator :@client, :receive_data

    def post_init
      puts "-- new connection --"
      @client = Engine::Client.new(em_connection: self)
    end

    def unbind
      puts "-- disconnect --"
    end
  end
end
