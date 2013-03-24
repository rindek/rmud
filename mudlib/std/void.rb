require "./mudlib/std/container"

module Std
  class Void < Std::Container
    def initialize(*args)
      super(*args)
    end

    def add(obj)
      obj.environment = nil
      obj = nil
    end
  end
end
