# frozen_string_literal: true
module Repos
  class RoomExits < Local
    option :dataset, default: -> { App[:database][:room_exits] }
    option :entity, default: -> { Entities::RoomExit }
  end
end
