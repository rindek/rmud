# frozen_string_literal: true
module Repos
  class Local
    extend Dry::Initializer
    include Dry::Monads[:result, :do, :maybe, :try]

    option :dataset, default: -> {  }
    option :entity, default: -> {  }

    def find_by(args)
      dataset.where(args).first.then { |record| record ? Some(wrap(record)) : None() }
    end

    def wrap(record)
      entity.new(record)
    end
  end
end
