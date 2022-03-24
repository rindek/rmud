# frozen_string_literal: true
module Traits
  module Inventory
    def inventory
      @inventory ||= ::Engine::Lib::Inventory.new(source: self)
    end

    def spawn(npcs: [], weapons: [], items: [])
      Array(npcs).each do |npc|
        case ImportContainer["repos.npcs"].find(npc)
        in Dry::Monads::Some[n]
          Engine::Actions::Move.call(object: n, dest: self)
        in Dry::Monads::None
          App[:logger].warn("Could not spawn '#{npc}' for #{self.class}(#{self.id}), NPC not found")
        end
      end

      Array(weapons).each do |weapon|
        case ImportContainer["repos.weapons"].find(weapon)
        in Dry::Monads::Some[w]
          Engine::Actions::Move.call(object: w, dest: self)
        in Dry::Monads::None
          App[:logger].warn("Could not spawn '#{weapon}' for #{self.class}(#{self.id}), weapon not found")
        end
      end

      Array(items).each do |item|
        case ImportContainer["repos.items"].find(item)
        in Dry::Monads::Some[i]
          Engine::Actions::Move.call(object: i, dest: self)
        in Dry::Monads::None
          App[:logger].warn("Could not spawn '#{item}' for #{self.class}(#{self.id}), item not found")
        end
      end
    end
  end
end
