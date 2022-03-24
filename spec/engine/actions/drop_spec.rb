# frozen_string_literal: true
RSpec.describe Engine::Actions::Drop do
  let(:action) { described_class.new }

  subject { action.call(item: item, player: player) }

  let(:player) { FactoryBot.create(:game_player) }

  context "When item is a weapon" do
    let(:item) { FactoryBot.create(:weapon) }

    it "calls unwield action before dropping" do
      expect(Engine::Actions::Unwield).to receive(:call).with(weapon: item, player: player).and_return(M.Success)
      expect(Engine::Actions::Move).to receive(:call)
        .with(object: item, dest: player.current_environment)
        .and_return(M.Success)

      expect(subject).to eq(M.Success(item))
    end
  end

  context "When item is a normal item" do
    let(:item) { FactoryBot.create(:item) }

    it "does not call unwield action before dropping" do
      expect(Engine::Actions::Unwield).to_not receive(:call)
      expect(Engine::Actions::Move).to receive(:call)
        .with(object: item, dest: player.current_environment)
        .and_return(M.Success)

      expect(subject).to eq(M.Success(item))
    end
  end
end
