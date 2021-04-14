# frozen_string_literal: true
RSpec.describe "Command.Game.zakoncz" do
  let(:command) do
    Engine::Commands::Game.resolve(:zakoncz).call(player: player).class.new(player: player, shutdown: shutdown_lib)
  end

  subject { command.call }
  let(:shutdown_lib) { instance_double(Engine::Lib::Shutdown) }

  let(:player) { build(:game_player) }

  context "Happy path" do
    before { expect(shutdown_lib).to receive(:call).with(player: player).and_return(M.Success) }

    it { is_expected.to be_successful }
  end
end
