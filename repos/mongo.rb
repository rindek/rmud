# frozen_string_literal: true
module Repos
  class Mongo
    extend Dry::Initializer
    include Dry::Monads[:result, :do, :maybe, :try]

    module T
      extend Dry::Transformer::Registry
      import Dry::Transformer::HashTransformations
    end

    option :dataset, default: -> { raise "dataset must be set" }
    option :entity, default: -> { raise "entity must be set" }

    def first
      find_by({})
    end

    def find_by(args)
      dataset.find(args).first.then { |record| record ? Some(wrap(record)) : None() }
    end

    def all_by(args)
      dataset.find(args).to_a.then { |records| records.empty? ? None() : Some(wrap_many(records)) }
    end

    def each(&block)
      dataset.find({}).each { |document| block.call(wrap(document)) }
    end

    private

    def wrap(record)
      entity.new(record)
    end

    def wrap_many(records)
      records.map { |record| wrap(record) }
    end
  end
end
