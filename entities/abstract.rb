# frozen_string_literal: true

module Entities
  class Abstract < Dry::Struct
    transform_keys(&:to_sym)

    include Dry::Monads[:try, :result]
  end
end
