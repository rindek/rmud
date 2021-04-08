# frozen_string_literal: true
module Engine
  module Command
    module Login
      class Zakoncz < Base
        def call(...)
          client.close
          Success(true)
        end
      end
    end
  end
end
