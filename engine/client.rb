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
      puts "adding '#{data.chomp}' to cmd queue"
      queue << data.chomp

      begin
        puts "WAITING: #{tp.waiting?}"
        if tp.waiting?
          tp.resume(queue.shift)
        else
          Thread.new do
            puts "acquiring semaphore"
            semaphore.acquire
            current_handler.receive(queue.shift)
            puts "releasing semaphore"
            semaphore.release
            tp.write("> ")
          end
        end
      rescue => e
        puts Backtrace.new(e)
        write("Wystapil powazny blad.\n")
      end
    end

    def handler=(new_handler)
      @handler = new_handler
      @current_handler = nil
    end

    private

    def current_handler
      @current_handler ||= handler.new(tp)
    end

    def tp
      @tp ||= Engine::Player.new(client: self)
    end
  end
end
