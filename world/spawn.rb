# encoding: UTF-8
Engine::Core.Room(
  id: Engine::Command::Login::Login::DEFAULT_SPAWN_ID,
  short: "spawn",
  long: "spawn",
  exits: [
    { to: Relative("special_room"), name: "wyjscie", joiner: "w kierunku" },
    { to: "world.redania.novigrad.passiflora.rooms.common", name: "passiflora" },
  ],
  callbacks: {
    after_load: ->(room) { Engine::Actions::Move.new.call(object: NPCS["main.ghost"], dest: room) },
  },
)

Engine::Core.Item(id: "main.spawn.sztylet", name: "sztylet", adjectives: %w[długi ostry])
Engine::Core.Item(id: "main.spawn.miecz", name: "miecz", adjectives: %w[krótki tępy])

Engine::Core.NPC(
  id: "main.ghost",
  adjectives: %w[przyjacielski],
  name: "duch",
  events: [
    "fruwa sobie",
    "nagle znika ale po chwili pojawia się",
    "przypatruje ci się uważnie",
    "migocze delikatnie",
    "wydaje z siebie dźwięki: uuu, oooo",
  ],
)
