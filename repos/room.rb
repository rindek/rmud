# frozen_string_literal: true
module Repos
  class Room < Local
    option :dataset, default: -> { App[:database][:rooms] }
    option :entity, default: -> { Entities::Room }

    def each_with_exits(&blk)
      dataset.all.each do |record|
        Repos::RoomExit.new.all_by(from_room_id: record[:id]).value_or { [] }.then do |exits|
          blk.call(wrap(record.merge(exits: exits)))
        end
      end
    end
  end
end
