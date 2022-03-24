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
    after_load: -> do
      _1.spawn(
        NPCS["main.ghost"],
        WEAPONS["main.spawn.sztylet"],
        WEAPONS[Relative("redania/novigrad/passiflora/items/knife")],
        ITEMS["main.spawn.fajka"],
      )
    end,
  },
)

Engine::Core.Weapon(
  id: "main.spawn.sztylet",
  name: "sztylet",
  adjectives: %w[długi ostry tępy wielki],
  hit_type: [Constants::Game::Weapon::HitType::PIERCE, Constants::Game::Weapon::HitType::SLASH],
  hand: Constants::Game::Weapon::Hand::SINGLE,
  dps: 8.0,
  level: 1,
  bonus: {
    dexterity: 1,
  },
  durability: 20,
  weight: 1.0,
)

Engine::Core.Weapon(
  id: "main.spawn.miecz",
  name: "miecz",
  adjectives: %w[krótki tępy],
  hit_type: [Constants::Game::Weapon::HitType::SLASH],
  hand: Constants::Game::Weapon::Hand::SINGLE,
  dps: 7.5,
  level: 1,
  durability: 20,
  weight: 1.5,
)

Engine::Core.Item(id: "main.spawn.fajka", name: "fajka", adjectives: %w[krótka])

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
