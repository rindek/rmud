unload Object, :Alarm

class Alarm
  @@alarms = []

  attr_accessor :current, :next_tick

  class << self
    def alarms
      @@alarms
    end

    def in(*args, &block)
      Alarm.new.in(*args, &block)
    end

    def repeat(*args, &block)
      Alarm.new.repeat(*args, &block)
    end
  end

  def in(sec)
    Alarm.new.repeat(sec, sec, 1) do
      yield
    end
  end

  def repeat(first, every, tick_count = -1)
    self.current = Thread.new {
      self.next_tick = (Time.now.to_f + first)
      sleep first
      yield

      if tick_count > 1
        tick_count.times do
          self.next_tick = (Time.now.to_f + every)
          sleep every
          yield
        end
      elsif tick_count == -1
        loop do
          self.next_tick = (Time.now.to_f + every)
          sleep every
          yield
        end
      end
      stop
    }
    @@alarms << self

    self
  end

  def stop
    @@alarms.delete(self)
    current.kill
  end

  private

  def next_tick_in(round = 6)
    (next_tick - Time.now.to_f).round(round)
  end
end
