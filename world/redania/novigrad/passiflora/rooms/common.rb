CORE.Room(
  short: "Passiflora common room",
  long: "Passiflora common room. There are a lot of guests",
  exits: [
    { to: Relative("secret/secret_room"), name: "north" },
    { to: Engine::Command::Login::Login::DEFAULT_SPAWN_ID, name: "outside" },
  ],
  callbacks: {
    after_load: -> { _1.spawn(NPCS[Relative("../npcs/Narcissa")]) },
  },
)
