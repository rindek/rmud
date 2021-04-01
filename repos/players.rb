# frozen_string_literal: true
module Repos
  class Players < Mongo
    option :dataset, default: -> { App[:mongo][:players] }
    option :entity, default: -> { Entities::Player }
  end
end
