Room(
  short: "another room short",
  long: "another room long",
  exits: [
    { to: Namespace("special_room"), name: "zachod" },
    { to: "yet_another_room", name: "drzwi", joiner: "w kierunku" },
  ],
  callbacks: {
    before_leave: ->(obj) { obj.write("before leave.\n") },
    after_leave: ->(obj) { obj.write("after leave.\n") },
    before_enter: ->(obj) { obj.write("before enter.\n") },
    after_enter: ->(obj) { obj.write("after enter.\n") },
  },
)
