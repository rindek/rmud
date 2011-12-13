require 'singleton'
require './mudlib/std/container'

module Std
  class Room < Std::Container
    include Singleton
    include Modules::Command

    attr_accessor :short, :long

    def initialize
      super()

      @exits = []
      @short = "Pokoj"
      @long = "To jest przykladowy pokoj.\n"
      @events = []
    end

    def set_event_time time
      @events_time = time
      if @events_time > 0
        alarm = Alarm.new
        alarm.repeat(time, time) do
          event = @events[rand(@events.size)]
          filter(Std::Player).each do |p|
            p.catch_msg(event)
          end
        end
      end
    end

    def add_event(event)
      @events << event
    end

    def add_exit(direction, room)
      if room.is_a?(String)
        room = room.split("/").map(&:capitalize).join("::").constantinize
      end
      @exits << {:direction => direction, :room => room}

      ## add_exit dodaje możliwość wywołania komendy 'go'
      ## w konkretnym kierunku, jeżeli nasz direction jest niestandardowy
      exits_obj = Cmd::Live::Exits.instance
      add_object_action(exits_obj.method(:go), direction)
    end

    def get_exits
      @exits
    end

    def get_exit(direction)
      exit = @exits.select {|e| e[:direction] == direction}.first
      if exit
        exit[:room].instance
      else
        nil
      end
    end


    def exits_description
      "Mozliwe wyjscia: #{@exits.collect {|exit| exit[:direction]}.join(", ")}"
    end

    # def get_exits
    #   @exits
    # end

    # def get_exit(direction)
    #   exit = @exits.select {|e| e[:direction] == direction || e[:direction] == direction.depolonize}.first
    #   if exit
    #     exit[:room].instance
    #   else
    #     nil
    #   end
    # end

    # def exits
    #   @exits.collect {|exit| exit[:direction]}.join(", ")
    # end
  end
end