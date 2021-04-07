Room(
  short: "another room short",
  long: "another room long",
  exits: [{ to: "app.world.special_room", name: "special" }, { to: "app.world.special_room", name: "stodola" }],
  before_enter: ->(obj) { puts "hello" },
)
