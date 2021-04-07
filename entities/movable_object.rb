# frozen_string_literal: true
module Entities
  class MovableObject < GameObject
    delegate :remove_self_from_inventory, to: :environment

    def current_environment
      environment.dest
    end

    def update_current_environment(dest)
      environment.update(dest)
    end

    def presentable
      name.capitalize
    end

    private

    def environment
      @environment ||= Engine::Lib::Environment.new(source: self)
    end
  end
end
