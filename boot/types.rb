# frozen_string_literal: true
App.boot(:types) do
  start do
    module ::Types
      include ::Dry.Types

      BSON = Types.Instance(BSON::ObjectId)
      ConcurrentArray = Types.Instance(Concurrent::Array)
      Proc = Types.Instance(Proc)

      def self.Entity(klass)
        Types.Constructor(klass) { |values| klass.new(values) }
      end

      def self.Resolvable(type)
        Types.Constructor(Proc) { |id| -> { GAME[type].resolve(id) } }
      end
    end

    use :zeitwerk
    use :core

    module ::Types
      module DB
        Player = Types.Instance(Entities::DB::Player)
        Dict = Types.Instance(Entities::DB::Dict)
      end

      module Game
        Room = Types.Instance(Entities::Game::Room)
        RoomExit = Types.Instance(Entities::Game::RoomExit)
        Player = Types.Instance(Entities::Game::Player)
        GameObject = Types.Instance(Entities::Game::GameObject)
        MovableObject = Types.Instance(Entities::Game::MovableObject)
        Environment = Types.Interface(:inventory)

        module Creature
          Attribute =
            Types::Symbol.enum(
              Constants::Game::Creature::Attribute::STRENGTH,
              Constants::Game::Creature::Attribute::DEXTERITY,
              Constants::Game::Creature::Attribute::STAMINA,
              Constants::Game::Creature::Attribute::INTELLIGENCE,
              Constants::Game::Creature::Attribute::WISDOM,
            )
        end

        module Item
          Rarity =
            Types::Symbol
              .default(Constants::Game::Item::Rarity::COMMON)
              .enum(
                Constants::Game::Item::Rarity::COMMON,
                Constants::Game::Item::Rarity::UNCOMMON,
                Constants::Game::Item::Rarity::RARE,
                Constants::Game::Item::Rarity::EPIC,
                Constants::Game::Item::Rarity::QUEST,
              )

          Bonus = Types::Hash.map(Types::Game::Creature::Attribute, Types::Integer).default({}.freeze)
        end

        module Weapon
          HitType =
            Types::Array.of(
              Types::Symbol.enum(
                Constants::Game::Weapon::HitType::PIERCE,
                Constants::Game::Weapon::HitType::SLASH,
                Constants::Game::Weapon::HitType::BLUNT,
              ),
            )

          Hand = Types::Symbol.enum(Constants::Game::Weapon::Hand::SINGLE, Constants::Game::Weapon::Hand::BOTH)
        end

        VOID = :void.freeze
      end
    end

    Dry::Types.load_extensions(:monads)
    Dry::Schema.load_extensions(:monads)

    GAME.register(:void, Types::Game::VOID)
  end
end
