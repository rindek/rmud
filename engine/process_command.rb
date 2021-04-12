# frozen_string_literal: true
module Engine
  class ProcessCommand
    extend Dry::Initializer

    include Dry::Monads[:try, :maybe]

    option :semaphore, default: -> { Concurrent::Semaphore.new(1) }

    def call(input:, handler:, client:)
      fetch_ivar.fmap { |ivar| return ivar.set(input) }

      Thread.new do
        semaphore.acquire

        begin
          handler.receive(input, client)
        rescue => e
          puts Backtrace.new(e)
          client.write("Wystapil powazny blad")
        ensure
          semaphore.release
          client.write(client.current_handler.prompt)
        end
      end
    end

    def aquire_lock!
      @ivar = Concurrent::IVar.new
      @ivar.value(60 * 5) # 5 minutes is good enough
    end

    private

    def fetch_ivar
      @ivar && @ivar.pending? ? Some(@ivar) : None()
    end
  end
end
