# frozen_string_literal: true
module Repos
  class Player < Local
    option :dataset, default: -> { App[:database][:players] }
    option :entity, default: -> { Entities::Player }
  end
end
