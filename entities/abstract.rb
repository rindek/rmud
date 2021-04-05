# frozen_string_literal: true

module Entities
  class Abstract < Dry::Struct
    transform_keys(&:to_sym)
  end
end
