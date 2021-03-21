# frozen_string_literal: true
module Repos
  class Players < Local
    option :dataset, default: -> { App[:database][:players] }
    option :entity, default: -> { Entities::Player }
  end
end
