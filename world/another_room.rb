Room(
  short: "another room short",
  long: "another room long",
  exits: [{ to: Namespace("special_room"), name: "special" }, { to: "app.world.yet_another_room", name: "drzwi" }],
  before_enter: ->(obj) { puts "hello" },
)
