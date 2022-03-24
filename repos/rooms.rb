# frozen_string_literal: true
module Repos
  class Rooms < Container
    option :dataset, default: -> { ROOMS }
    option :entity, default: -> { Entities::Game::Room }
  end
end
