class Callbacks
  @@callbacks = {}

  class << self
    def add(name, &block)
      (@@callbacks[name] ||= []) << block
    end

    def execute(name)
      @@callbacks[name].each do |callbacks|
        callbacks.call
      end
    end
  end
end

