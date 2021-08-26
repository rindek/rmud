# frozen_string_literal: true
module Traits
  module Environment
    delegate :remove_self_from_inventory, to: :_environment

    def current_environment
      _environment.dest
    end

    def update_current_environment(dest)
      _environment.update(dest)
    end

    private

    def _environment
      @_environment ||= Engine::Lib::Environment.new(source: self)
    end
  end
end
