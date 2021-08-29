# frozen_string_literal: true
module Entities
  module Game
    class GameObject < Abstract
      def decorator(observer: None)
        raise "implement me"
      end
    end
  end
end
