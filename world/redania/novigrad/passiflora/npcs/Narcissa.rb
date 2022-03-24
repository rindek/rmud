CORE.NPC(
  adjectives: %w[young blackhair],
  name: "woman",
  events: ["looks at you", "drinks something from a dirty cup", "sighs"],
  callbacks: {
    after_clone: -> { _1.spawn(weapons: Relative("../items/knife")) },
  },
)
