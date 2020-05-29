# frozen_string_literal: true
module Traits
  module Movable
    def move(to:)
      Engine::Actions::Move.new(object: self, dest: to).call
    end
  end
end
