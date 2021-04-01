# frozen_string_literal: true
module Repos
  class Rooms < Mongo
    option :dataset, default: -> { App[:mongo][:rooms] }
    option :entity, default: -> { Entities::Room }
  end
end
