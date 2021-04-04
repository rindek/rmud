# frozen_string_literal: true
module Repos
  class Rooms < Local
    option :dataset, default: -> { App[:mongo][:rooms] }
    option :entity, default: -> { Entities::Room }
  end
end
