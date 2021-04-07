# frozen_string_literal: true

module Entities
  class Abstract < Dry::Struct
    transform_keys(&:to_sym)

    include Dry::Monads[:try, :result, :do]

    def to_ref
      "abstract"
    end
  end
end
