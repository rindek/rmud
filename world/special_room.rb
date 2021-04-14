Room(
  short: "a spawn room short",
  long: "a long room long",
  exits: [
    { to: "app.world.another_room", name: "wschod" },
    { to: "app.world.yet_another_room", name: "drzwi", joiner: "przez" },
    { to: "app.world.spawn", name: "spawn" },
  ],
  callbacks: {
    before_enter: ->(obj) { obj.write("Nie weszłeś.\n") },
    after_enter: ->(obj) { obj.write("Weszłeś.\n") },
  },
)
