# frozen_string_literal: true
RSpec.describe Engine::Actions::Move do
  let(:action) { described_class.new(object: object, dest: dest) }

  subject { action. }

  let(:object) { build(:movable_object) }
  let(:dest) { build(:room) }

  context "Happy path" do
    context "object was in other inventory before" do
      let(:other_dest) { build(:room) }

      before do
        other_dest.inventory.add(object)
        object.environment = other_dest
      end

      it "changes environment" do
        expect { subject }.to change { object.environment }
      end

      it "removes itself from other inventory" do
        expect { subject }.to change { other_dest.inventory.items }.from([object]).to([])
      end
    end

    it { is_expected.to hold(object) }

    it "changes environment properly" do
      expect { subject }.to change { object.environment }.to(dest)
    end

    it "object is inside destination inventory" do
      expect { subject }.to change { dest.inventory.items }.from([]).to([object])
    end
  end

  context "setting new environment fails" do
    before { allow(object).to receive(:environment=) }

    it { is_expected.to cause(:wrong_object_environment) }
  end

  context "moving to destination inventory fails" do
    before { allow(dest.inventory).to receive(:add) }

    it { is_expected.to cause(:missing_object_in_inventory) }
  end
end
