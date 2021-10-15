# frozen_string_literal: true
RSpec.describe Engine::Actions::Move do
  let(:action) { described_class.new }

  subject { action.call(object: object, dest: dest) }

  let(:object) { build(:movable_object) }
  let(:dest) { build(:room) }

  context "Happy path" do
    context "object was in other inventory before" do
      let(:other_dest) { build(:room) }

      before do
        other_dest.inventory.add(object)
        object.update_current_environment(other_dest)
      end

      it "changes environment" do
        expect { subject }.to change { object.current_environment }
      end

      it "removes itself from other inventory" do
        expect { subject }.to change { other_dest.inventory.elements }.from([object]).to([])
      end
    end

    it { is_expected.to hold(object) }

    it "changes environment properly" do
      expect { subject }.to change { object.current_environment }.to(dest)
    end

    it "object is inside destination inventory" do
      expect { subject }.to change { dest.inventory.elements }.from([]).to([object])
    end
  end

  context "setting new environment fails" do
    before { allow(object).to receive(:current_environment).and_return(:wrong) }

    it { is_expected.to cause(:wrong_object_environment) }
  end

  context "moving to destination inventory fails" do
    before { allow(dest.inventory).to receive(:add) }

    it { is_expected.to cause(:missing_object_in_inventory) }
  end
end
