Engine::Core.Room(
  short: "a spawn room short",
  long: "a long room long",
  exits: [
    { to: Relative("another_room"), name: "wschod" },
    { to: Relative("yet_another_room"), name: "drzwi", joiner: "przez" },
    { to: Engine::Command::Login::Login::DEFAULT_SPAWN_ID, name: "spawn" },
  ],
  callbacks: {
    before_enter: ->(obj) { obj.write("Nie weszłeś.\n") },
    after_enter: ->(obj) { obj.write("Weszłeś.\n") },
  },
)
