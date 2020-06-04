# frozen_string_literal: true
module Engine
  class Player
    extend Dry::Initializer

    option :client, type: Types.Instance(Engine::Client)
    option :ivar, default: -> { Concurrent::IVar.new }

    delegate :close, :write, to: :client

    def resume(data)
      @waiting = false
      ivar.set(data)
    end

    def waiting?
      !!@waiting
    end

    def wait!
      @waiting = true
    end

    def reset!
      @waiting = false
      @ivar = Concurrent::IVar.new
    end
  end
end
