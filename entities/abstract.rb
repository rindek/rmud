# frozen_string_literal: true
module Entities
  class Abstract < Dry::Struct
    include Dry::Monads[:maybe]
    transform_keys(&:to_sym)
  end
end
