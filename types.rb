module ::Types
  include ::Dry.Types

  Room = Types.Instance(Entities::Room)
  PlayerObject = Types.Instance(Entities::Player)
  GameObject = Types.Instance(Entities::GameObject)
  MovableObject = Types.Instance(Entities::MovableObject)

  VOID = :void.freeze
end

Dry::Types.load_extensions(:monads)
