Room(
  short: "a spawn room short",
  long: "a long room long",
  exits: [
    { to: "app.world.another_room", name: "wschod" },
    { to: "app.world.yet_another_room", name: "drzwi", joiner: "przez" },
  ],
  before_enter: ->(obj) { puts "hello" },
)
