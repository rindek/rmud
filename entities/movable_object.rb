# frozen_string_literal: true
module Entities
  class MovableObject < GameObject
    include Traits::Movable

    def environment
      @environment ||= Engine::Lib::Environment.new(source: self)
    end
  end
end
