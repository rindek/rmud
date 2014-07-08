$reboot = false

class Rmud
  class << self
    def root
      Pathname(Dir.pwd)
    end

    def world
      root.join("world")
    end

    def env
      environment
    end

    def environment
      ENV["RMUD_ENV"] || "development"
    end

    def development?
      environment == "development"
    end

    def production?
      environment == "production"
    end
  end
end
