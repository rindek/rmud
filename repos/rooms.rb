# frozen_string_literal: true
module Repos
  class Rooms < Local
    option :dataset, default: -> { App[:database][:rooms] }
    option :entity, default: -> { Entities::Room }

    include Import["repos.room_exits"]

    def each_with_exits(&blk)
      dataset.all.each do |record|
        room_exits.all_by(from_room_id: record[:id]).value_or { [] }.then do |exits|
          blk.call(wrap(record.merge(exits: exits)))
        end
      end
    end
  end
end
