class Rmud
  class << self
    def root
      Dir.pwd
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
