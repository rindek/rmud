# frozen_string_literal: true
module Repos
  class Players < Local
    option :dataset, default: -> { App[:mongo][:players] }
    option :entity, default: -> { Entities::DB::Player }

    def find_by_name(name:)
      find_by(name: name)
    end
  end
end
