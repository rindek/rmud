# frozen_string_literal: true
module Engine
  module Actions
    class Abstract
      include Dry::Monads[:do, :result, :maybe]
      extend Dry::Initializer

      def self.call(**args)
        new.(**args)
      end
    end
  end
end
