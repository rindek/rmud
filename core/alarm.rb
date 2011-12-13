class Alarm
  @@alarms = []

  attr_reader :current, :next_tick

  @current = nil

  def next_tick_in(round=6)
    (@next_tick - Time.now.to_f).round(round)
  end

  def in(sec)
    Alarm.new.repeat(sec, sec, 1) do
      yield
    end
  end

  def repeat(first, every, tick_count = -1)
    @current = Thread.new {
      @next_tick = (Time.now.to_f + first)
      sleep first
      yield

      if tick_count > 1
        tick_count.times do
          @next_tick = (Time.now.to_f + every)
          sleep every
          yield
        end
      elsif tick_count == -1
        loop do
          @next_tick = (Time.now.to_f + every)
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
    @current.kill
  end

  def self.alarms
    @@alarms
  end
end

