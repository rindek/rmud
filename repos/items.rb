module Repos
  class Items < Container
    option :dataset, default: -> { ITEMS }
    option :entity, default: -> { Entities::Game::Item }
  end
end
