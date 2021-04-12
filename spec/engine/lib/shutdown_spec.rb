# frozen_string_literal: true
RSpec.xdescribe Engine::Lib::Shutdown do
  let(:lib) { described_class.new }

  describe "#call" do
    subject { lib.call(player: player) }
    let(:player) { build(:game_player) }

    context "happy path" do
      after { subject }
      it "expects to remove itself from inventory" do
        expect(player).to receive(:remove_self_from_inventory)
      end
    end
  end
end
