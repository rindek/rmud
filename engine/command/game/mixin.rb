# frozen_string_literal: true
module Engine
  module Command
    module Game
      module Mixin
        def register_command(name, callback, imports = [])
          klass =
            Class.new(Engine::Command::Game::Base) do
              include Dry::Monads[:try, :maybe, :result]
              include Import[*imports]

              define_method(:call) { |*args| instance_exec player, *args, &callback }
            end

          register(name) { |player:| klass.new(player: player) }
        end
      end
    end
  end
end
