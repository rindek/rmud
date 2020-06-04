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

    def receive_data(data)
      process_command((queue << data.chomp).shift)
    end

    def process_command(data)
      return tp.continue(data) if tp.reading?

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

    private

    def lock!
      semaphore.acquire
    end

    def release!
      semaphore.release
      write("> ")
    end

    def current_handler
      @current_handler ||= handler.new(tp)
    end

    def tp
      @tp ||= Engine::Player.new(client: self)
    end
  end
end
