Engine::Core.Room(
  short: "Passiflora common room",
  long: "Passiflora common room. There are a lot of guests",
  exits: [
    { to: Relative("secret/secret_room"), name: "north" },
    { to: Engine::Command::Login::Login::DEFAULT_SPAWN_ID, name: "outside" },
  ],
  callbacks: {
    after_load: ->(room) do
      Engine::Actions::Move.new.call(object: NPCS["world.redania.novigrad.passiflora.npcs.Narcissa"], dest: room)
    end,
  },
)
