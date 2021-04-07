# frozen_string_literal: true
module Entities
  class Player < Creature
    attribute :id, Types::Coercible::String
    attribute :name, Types::String
    attribute :password, Types::String

    # def environment
    #   Try[Dry::Container::Error] { App[:game].resolve(environment_ref) }.to_maybe
    # end

    # def inventory
    #   inventory_refs.map do |ref|
    #     Try[Dry::Container::Error] { App[:game].resolve(ref) }.to_maybe.value_or { nil }
    #   end.compact
    # end
    include Traits::Inventory
  end
end
