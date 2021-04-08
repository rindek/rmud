# frozen_string_literal: true
module Repos
  class Players < Local
    option :dataset, default: -> { App[:mongo][:players] }
    option :entity, default: -> { Entities::DB::Player }
  end
end
