module Repos
  class Weapons < Container
    option :dataset, default: -> { WEAPONS }
    option :entity, default: -> { Entities::Game::Weapon }
  end
end
