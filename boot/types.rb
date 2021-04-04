# frozen_string_literal: true
App.boot(:types) do
  start do
    module ::Types
      include ::Dry.Types

      BSON = Types.Instance(BSON::ObjectId)

      def self.Entity(klass)
        Types.Constructor(klass) { |values| klass.new(values) }
      end
    end

    use :zeitwerk

    module ::Types
      Room = Types.Instance(Entities::Room)
      PlayerObject = Types.Instance(Entities::Player)
      GameObject = Types.Instance(Entities::GameObject)
      MovableObject = Types.Instance(Entities::MovableObject)

      VOID = :void.freeze
    end

    Dry::Types.load_extensions(:monads)
  end
end
