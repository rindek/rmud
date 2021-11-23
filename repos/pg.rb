# frozen_string_literal: true
module Repos
  class Pg
    extend Dry::Initializer
    include Dry::Monads[:result, :do, :maybe, :try]

    option :dataset, default: -> { raise "dataset must be set" }
    option :entity, default: -> { raise "entity must be set" }

    def first
      find_by({})
    end

    def find_by(args)
      dataset.where(args).first.then { |record| record ? Some(wrap(record)) : None() }
    end

    def all_by(args)
      dataset.where(args).all.then { |records| records.empty? ? None() : Some(wrap_many(records)) }
    end

    def each(&block)
      dataset.all.each { |record| block.call(wrap(record)) }
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
