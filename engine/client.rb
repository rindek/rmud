# frozen_string_literal: true
module Engine
  class Client
    extend Dry::Initializer

    option :em_connection
    option :handler, default: -> { Engine::Handlers::Login }
    option :semaphore, default: -> { Concurrent::Semaphore.new(1) }
    option :queue, default: -> { [] }

    def close
      em_connection.close_connection
    end

    def write(msg)
      em_connection.send_data(msg)
    end

    ## triggered from EM
    def receive_data(data)
      process_command((queue << data.chomp).shift)
    end

    def process_command(data)
      return continue(data) if reading?

      Thread.new do
        lock!

        begin
          current_handler.receive(data)
        rescue => e
          puts Backtrace.new(e)
          write("Wystapil powazny blad")
        ensure
          release!
        end
      end
    end

    def handler=(new_handler)
      @current_handler = new_handler
    end

    def read_client
      # asynchronously wait for this variable to be set by next
      # received data, name of method is for simplicity when
      # implementing
      @ivar = Concurrent::IVar.new
      @ivar.value(60 * 5) # 5 minutes is good enough
    end

    private

    def lock!
      semaphore.acquire
    end

    def release!
      semaphore.release
      write("> ")
    end

    def continue(data)
      @ivar.set(data)
      @ivar = nil
    end

    def reading?
      @ivar && @ivar.pending?
    end

    def current_handler
      @current_handler ||= handler.new(client: self)
    end
  end
end
