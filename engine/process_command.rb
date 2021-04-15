# frozen_string_literal: true
module Engine
  class ProcessCommand
    extend Dry::Initializer

    include Dry::Monads[:try, :maybe]

    option :semaphore, default: -> { Concurrent::Semaphore.new(1) }

    def call(input:, handler:, client:, write_prompt:)
      fetch_ivar.fmap { |ivar| return ivar.set(input) }

      Thread.new do
        semaphore.acquire

        begin
          handler.receive(input, client)
        rescue => e
          puts Backtrace.new(e)
          pp error_data(input, client)

          Rollbar.error(e, error_data(input, client))
          client.write("Wystąpił poważny błąd.\n")
        ensure
          semaphore.release
          if write_prompt
            Concurrent::Promises.future(0.01) do |duration|
              sleep(duration)
              client.write(client.current_handler.prompt)
            end
          end
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

    def error_data(input, client)
      {
        input: input,
        current_handler: client.current_handler.class,
        player_info: client.current_player.bind { |player| player.dump_info },
      }
    end
  end
end
