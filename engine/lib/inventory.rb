# frozen_string_literal: true
module Engine
  module Lib
    class Inventory < Abstract
      extend Dry::Initializer

      option :source, type: Types::GameObject
      option :items, type: Types::Array.of(Types::GameObject), default: -> { [] }

      def add(item)
        yield validate_item(item: item)
        items << item

        Success(item)
      end

      def remove(item)
        Maybe(items.delete(item)).to_result
      end

      def has?(item)
        items.include?(item)
      end

      def inspect
        "<Inventory of #{source.class}(#{source.object_id}) items=#{items.count}>"
      end

      private

      def validate_item(item:)
        return Success(true) if item.is_a?(Entities::GameObject)
        Failure(:not_game_object)
      end
    end
  end
end
