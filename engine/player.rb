# frozen_string_literal: true
module Engine
  class Player
    extend Dry::Initializer

    option :client, type: Types.Instance(Engine::Client)

    delegate :close, :write, to: :client

    def read_client
      @ivar = Concurrent::IVar.new
      @ivar.value(60 * 5) # 5 minutes is good enough
    end

    def continue(data)
      @ivar.set(data)
      @ivar = nil
    end

    def reading?
      @ivar && @ivar.pending?
    end
  end
end
