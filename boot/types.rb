# frozen_string_literal: true
App.boot(:types) do
  start do
    module ::Types
      include ::Dry.Types

      BSON = Types.Instance(BSON::ObjectId)
      ConcurrentArray = Types.Instance(Concurrent::Array)

      def self.Entity(klass)
        Types.Constructor(klass) { |values| klass.new(values) }
      end

      def self.Resolvable(type)
        Types.Constructor(Proc) { |id| -> { App[:game][type].resolve(id) } }
      end
    end

    use :zeitwerk

    module ::Types
      module DB
        Player = Types.Instance(Entities::DB::Player)
      end

      module Game
        Room = Types.Instance(Entities::Game::Room)
        Player = Types.Instance(Entities::Game::Player)
        GameObject = Types.Instance(Entities::Game::GameObject)
        MovableObject = Types.Instance(Entities::Game::MovableObject)

        VOID = :void.freeze
      end
    end

    Dry::Types.load_extensions(:monads)
    Dry::Schema.load_extensions(:monads)

    App[:game].register(:void, Types::Game::VOID)
  end
end
