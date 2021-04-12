# frozen_string_literal: true
RSpec.describe Engine::Lib::Shutdown do
  let(:lib) { described_class.new }

  describe "#call" do
    subject { lib.call(player: player) }
    let(:player) { build(:game_player) }

    context "happy path" do
      after { subject }

      it "removes player from inventory" do
        expect(player).to receive(:remove_self_from_inventory)
      end

      it "closes connection" do
        expect(player.client).to receive(:close)
      end

      it "removes itself from global PLAYER variable" do
        subject
        expect(App[:players][player.name]).to be_nil
      end
    end
  end
end
