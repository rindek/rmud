# frozen_string_literal: true
module Engine
  module Lib
    class Abstract
      include Dry::Monads[:do, :result, :maybe, :try]
      extend Dry::Initializer

      def self.call(...)
        new.call(...)
      end
    end
  end
end
