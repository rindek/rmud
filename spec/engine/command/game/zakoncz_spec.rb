# frozen_string_literal: true
RSpec.describe Engine::Command::Game::Zakoncz do
  let(:command) { described_class.new(player: player) }

  subject { command.call }

  let(:player) { build(:game_player) }

  context "Happy path" do
    before { expect(player.client).to receive(:close) }

    it { is_expected.to be_successful }

    it "cleans object from game" do
      expect(command).to receive(:clean_up)
      subject
    end
  end
end
