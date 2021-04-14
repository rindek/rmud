# frozen_string_literal: true
module Engine
  module Events
    class Base
      include Dry::Monads[:do, :result, :maybe]
      extend Dry::Initializer

      Schema = Dry::Schema.Params {}

      def self.call(**args)
        new.(**args)
      end

      def execute(...)
        raise "implement in subclass"
      end

      def call(input)
        self.class::Schema.call(input).to_monad.bind { execute(**input) }
      end
    end
  end
end
