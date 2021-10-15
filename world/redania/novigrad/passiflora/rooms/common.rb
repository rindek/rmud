Room(
  short: "Passiflora common room",
  long: "Passiflora common room. There are a lot of guests",
  exits: [
    { to: Namespace("secret_room"), name: "north" },
    { to: Engine::Command::Login::Login::DEFAULT_SPAWN_ID, name: "outside" },
  ],
  callbacks: {
    after_load: ->(room) do
      Engine::Actions::Move.new.call(object: App[:game][:npcs]["redania.novigrad.passiflora.npcs.Narcissa"], dest: room)
    end,
  },
)
