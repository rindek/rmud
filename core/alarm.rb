class Alarm
  @@alarms = []

  @current = nil

  def in(sec)
    @current = Thread.new {
      sleep sec
      yield
      stop
    }
    @@alarms << self

    self
  end

  def repeat(first, every, tick_count = -1)
    @thread = Thread.new {
      sleep first
      if tick_count > 0
        tick_count.times do
          yield
          sleep every
        end
      else
        loop do
          yield
          sleep every
        end
      end
      stop
    }
    @@alarms << self

    self
  end

  def stop
    @@alarms.delete(self)
    @thread.kill
  end

  def self.alarms
    @@alarms
  end
end

