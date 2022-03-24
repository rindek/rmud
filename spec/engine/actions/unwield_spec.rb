# frozen_string_literal: true
RSpec.describe Engine::Actions::Unwield do
  let(:action) { described_class.new }

  subject { action.call(weapon: weapon, player: player) }

  let(:player) { FactoryBot.create(:game_player) }
  let(:weapon) { FactoryBot.create(:weapon) }

  context "when weapon is not wielded" do
    it "returns successfuly" do
      expect(subject).to be_success
    end

    it "does not change slots table" do
      expect { subject }.not_to change { player.slots }
    end
  end

  context "when weapon is wielded (one-hand case)" do
    before { Engine::Actions::Wield.call(weapon: weapon, player: player) }

    it "player slots properly shows wielded weapon" do
      expect(player.slots.slice(:right_hand, :left_hand)).to eq(right_hand: M.Some(weapon), left_hand: M.None)
    end

    it "clears the slot after unwielding" do
      expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
        right_hand: M.None,
        left_hand: M.None,
      )
    end
  end

  context "when weapon is wielded (two-hand case)" do
    let(:weapon) { FactoryBot.create(:weapon, :two_hand) }

    before { Engine::Actions::Wield.call(weapon: weapon, player: player) }

    it "player slots properly shows wielded weapon" do
      expect(player.slots.slice(:right_hand, :left_hand)).to eq(right_hand: M.Some(weapon), left_hand: M.Some(weapon))
    end

    it "clears slots after unwielding" do
      expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
        right_hand: M.None,
        left_hand: M.None,
      )
    end
  end

  context "when two single-handed weapons are wielded" do
    let(:right_weapon) { FactoryBot.create(:weapon) }
    let(:left_weapon) { FactoryBot.create(:weapon) }

    before do
      Engine::Actions::Wield.call(weapon: right_weapon, player: player)
      Engine::Actions::Wield.call(weapon: left_weapon, player: player)
    end

    it "player slots properly shows wielded weapons" do
      expect(player.slots.slice(:right_hand, :left_hand)).to eq(
        right_hand: M.Some(right_weapon),
        left_hand: M.Some(left_weapon),
      )
    end

    context "unwielding right hand weapon" do
      subject { action.call(weapon: right_weapon, player: player) }

      it "clears proper slots after unwielding" do
        expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
          right_hand: M.None,
          left_hand: M.Some(left_weapon),
        )
      end
    end

    context "unwielding left hand weapon" do
      subject { action.call(weapon: left_weapon, player: player) }
      it "clears proper slots after unwielding" do
        expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
          right_hand: M.Some(right_weapon),
          left_hand: M.None,
        )
      end
    end
  end
end
