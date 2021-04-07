Room(
  short: "a spawn room short",
  long: "a long room long",
  exits: [{ to: "app.world.another_room", name: "wyjscie" }, { to: "app.world.yet_another_room", name: "drzwi" }],
  before_enter: ->(obj) { puts "hello" },
)
