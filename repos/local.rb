# frozen_string_literal: true
module Repos
  class Local
    extend Dry::Initializer
    include Dry::Monads[:result, :do, :maybe, :try]

    option :dataset, default: -> {  }
    option :entity, default: -> {  }

    def first
      find_by({})
    end

    def find_by(args)
      dataset.where(args).first.then { |record| record ? Some(wrap(record)) : None() }
    end

    def all_by(args)
      dataset.where(args).all.then { |records| records.empty? ? None() : Some(wrap_many(records)) }
    end

    def wrap(record)
      entity.new(record)
    end

    def wrap_many(records)
      records.map { |record| wrap(record) }
    end
  end
end
