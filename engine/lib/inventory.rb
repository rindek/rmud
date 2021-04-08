# frozen_string_literal: true
module Engine
  module Lib
    class Inventory < Abstract
      option :source, type: Types::Game::GameObject
      option :items, type: Types::ConcurrentArray, default: -> { Concurrent::Array.new }

      def add(item)
        yield validate_item(item: item)
        items << item

        Success(item)
      end

      def remove(item)
        Maybe(items.delete(item))
      end

      def has?(item)
        items.include?(item)
      end

      def inspect
        "<Inventory of #{source.class}(#{source.object_id}) items=#{items.count}>"
      end

      def players(without: nil)
        items.select { |item| item.is_a?(Entities::Game::Player) }.then do |items|
          without ? items.reject { |item| item == without } : items
        end
      end

      private

      def validate_item(item:)
        return Success(true) if item.is_a?(Entities::Game::MovableObject)
        Failure(:not_game_object)
      end
    end
  end
end
