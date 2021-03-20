# frozen_string_literal: true
module Repos
  class RoomExit < Local
    option :dataset, default: -> { DB[:room_exits] }
    option :entity, default: -> { Entities::RoomExit }
  end
end
