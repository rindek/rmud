# encoding: UTF-8
Room(
  id: Engine::Command::Login::Login::DEFAULT_SPAWN_ID,
  short: "spawn",
  long: "spawn",
  exits: [{ to: Namespace("special_room"), name: "wyjscie", joiner: "w kierunku" }],
  callbacks: {
    after_load: -> { puts "loaded" },
  },
)

Item(id: "main.spawn.sztylet", name: "sztylet", adjectives: %w[długi ostry])
Item(id: "main.spawn.miecz", name: "miecz", adjectives: %w[krótki tępy])
