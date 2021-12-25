Engine::Core.Room(
  short: "Passiflora common room",
  long: "Passiflora common room. There are a lot of guests",
  exits: [
    { to: Relative("secret/secret_room"), name: "north" },
    { to: Engine::Command::Login::Login::DEFAULT_SPAWN_ID, name: "outside" },
  ],
  spawn: -> { [NPCS[Relative("../npcs/Narcissa")]] },
)
