# frozen_string_literal: true
RSpec.xdescribe Engine::Command::Zakoncz do
  let(:command) { described_class.new(client: client, tp: tp) }

  subject { command.() }

  let(:client) { instance_double(Engine::Client) }
  let(:tp) { build(:player) }

  context "Happy path" do
    it { is_expected.to be_successful }
  end
end
