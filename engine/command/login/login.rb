# frozen_string_literal: true
module Engine
  module Command
    module Login
      class Login < Base
        include Import["repos.players"]

        DEFAULT_SPAWN_ID = "main.spawn".freeze

        def call(name)
          player = yield find_player(name)
          password = yield get_password

          yield authenticate(player, password)

          yield (in_game?(player.name) ? take_control(player.name, client) : spawn(player, client))

          Success()
        end

        private

        def find_player(name)
          players.find_by_name(name: name).or { Failure("Nie ma takiego gracza #{name}.\n") }
        end

        def get_password
          client.write("Podaj haslo: ")
          Success(client.read_client)
        end

        def authenticate(player, password)
          BCrypt::Password.new(player.password) == password ? Success(true) : Failure("Niepoprawne haslo.\n")
        end

        def in_game?(name)
          PLAYERS.key?(name)
        end

        def spawn(player, client)
          entity = Entities::Game::Player.new(data: player, client: client)
          PLAYERS[player.name] = entity
          entity.client.handler = Engine::Handlers::Game.new(player: entity)

          room_to_move = ROOMS[DEFAULT_SPAWN_ID]

          Engine::Events::Rooms::BeforeEnter.call(who: entity, to_room: room_to_move)
          yield (
            Engine::Actions::Move
              .call(object: entity, dest: room_to_move)
              .or do |failure|
                App[:logger].debug(failure)
                Failure("Wystapil blad podczas przenoszenia.\n")
              end
          )
          Engine::Events::Rooms::AfterEnter.call(who: entity, to_room: room_to_move)

          entity.client.write("Zalogowano!\n")
          entity.client.receive_data("spojrz", write_prompt: false)

          Success()
        end

        def take_control(name, client)
          client.handler = Engine::Handlers::Game.new(player: PLAYERS[name])
          PLAYERS[name].replace_client(client)
          Success()
        end
      end
    end
  end
end
