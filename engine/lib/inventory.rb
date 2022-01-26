# frozen_string_literal: true
module Engine
  module Lib
    class Inventory < Abstract
      option :source, type: Types::Game::GameObject
      option :elements, type: Types::ConcurrentArray, default: -> { Concurrent::Array.new }

      def add(item)
        yield validate_item(item: item)
        elements << item

        Success(item)
      end

      def remove(item)
        Maybe(elements.delete(item))
      end

      def has?(item)
        elements.include?(item)
      end

      def inspect
        "<Inventory of #{source.class}(#{source.object_id}) elements=#{elements.count}>"
      end

      def filter(entity:, without:)
        elements.select { |item| item.is_a?(entity) }.then { |elements| without ? elements - Array(without) : elements }
      end

      def players(without: nil)
        filter(entity: Entities::Game::Player, without: without)
      end

      def creatures(without: nil)
        filter(entity: Entities::Game::Creature, without: without)
      end

      def items(without: nil)
        filter(entity: Entities::Game::Item, without: without)
      end

      def weapons(without: nil)
        filter(entity: Entities::Game::Weapon, without: without)
      end

      private

      def validate_item(item:)
        return Success(true) if item.is_a?(Entities::Game::MovableObject)
        Failure(:not_game_object)
      end
    end
  end
end
