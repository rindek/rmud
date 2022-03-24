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
end
