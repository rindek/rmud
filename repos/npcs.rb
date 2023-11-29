module Repos
  class Npcs < Container
    option :dataset, default: -> { NPCS }
    option :entity, default: -> { Entities::Game::Creature }
  end
end
