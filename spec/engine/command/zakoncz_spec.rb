# frozen_string_literal: true
RSpec.describe Engine::Command::Zakoncz do
  let(:command) { described_class.new(client: client, tp: tp) }

  subject { command.call }

  let(:client) { Engine::Client.new(em_connection: FakeSocketClient.new(nil)) }
  let(:tp) { build(:player) }

  context "Happy path" do
    before { expect(client).to receive(:close) }

    it { is_expected.to be_successful }

    it "cleans object from game" do
      expect(command).to receive(:clean_up)
      subject
    end
  end
end
