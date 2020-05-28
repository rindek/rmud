# frozen_string_literal: true

module Entities
  class Inventory
    extend Dry::Initializer

    option :environment, type: Types::Any

    # attr_accessor :objects

    # def add(obj)
    #   objects << obj
    #   obj.environment = self
    # end

    # def remove(object)
    # end
  end
end
