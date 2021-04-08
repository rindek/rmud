# frozen_string_literal: true
module Engine
  module Command
    module Login
      class Login < Base
        include Import["repos.players"]

        DEFAULT_SPAWN_ID = "app.world.spawn".freeze

        def call(name)
          player = yield find_player(name)
          password = yield get_password

          yield authenticate(player, password)

          entity = Entities::Game::Player.new(data: player, client: client)

          PLAYERS[name] = entity

          entity.client.handler = Engine::Handlers::Game.new(player: entity)
          yield spawn(entity)

          entity.client.write("Zalogowano!\n")
          entity.client.receive_data("spojrz")

          Success(entity)
        end

        private

        def find_player(name)
          players.find_by(name: name).or { Failure("Nie ma takiego gracza #{name}.\n") }
        end

        def get_password
          client.write("Podaj haslo: ")
          Success(client.read_client)
        end

        def authenticate(player, password)
          BCrypt::Password.new(player.password) == password ? Success(true) : Failure("Niepoprawne haslo.\n")
        end

        def spawn(entity)
          Engine::Actions::Move
            .call(object: entity, dest: App[:game][:rooms][DEFAULT_SPAWN_ID])
            .or do |failure|
              App[:logger].debug(failure)
              Failure("Wystapil blad podczas przenoszenia.\n")
            end
        end
      end
    end
  end
end
