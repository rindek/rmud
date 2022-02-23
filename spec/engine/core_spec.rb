RSpec.describe Engine::Core do
  describe "#Relative" do
    let(:core) { described_class }
    let(:base_absolute) { "/app/world/room.rb" }

    before { allow(caller_locations).to receive(:first).and_return(double(path: base_absolute)) }

    it { expect(core.Relative("another_room", base_absolute)).to eq("wold.another_room") }
    it { expect(core.Relative("folder/room", base_absolute)).to eq("world.folder.room") }
    it { expect(core.Relative("../domain/folder/room", base_absolute)).to eq("domain.folder.room") }
  end
end
