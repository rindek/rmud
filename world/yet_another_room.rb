Room(
  short: "another room short",
  long: "another room long",
  exits: [{ to: "special_room", name: "drzwi" }],
  before_enter: ->(obj) { puts "hello" },
)
