# frozen_string_literal: true
RSpec.describe Engine::Lib::Inventory do
  let(:lib) { described_class.new(source: source, elements: elements) }
  let(:elements) { Concurrent::Array.new }
  let(:source) { build(:game_object) }
  let(:item) { build(:movable_object) }

  describe "#add" do
    subject { lib.add(item) }

    context "item is a valid game object" do
      it { is_expected.to hold(item) }

      it "updates elements list" do
        expect { subject }.to change { lib.elements.count }.by(1)
      end
    end

    context "item is not game object" do
      let(:item) { :item }

      it { is_expected.to cause(:not_game_object) }
    end
  end

  describe "#remove" do
    subject { lib.remove(item) }

    context "when item exists" do
      let(:elements) { Concurrent::Array.new [item] }

      it { is_expected.to hold(item) }
    end

    context "when item does not exist" do
      let(:elements) { Concurrent::Array.new [] }

      it { is_expected.to be_none }
    end
  end

  describe "#has?" do
    subject { lib.has?(item) }

    context "item exists in inventory" do
      let(:elements) { Concurrent::Array.new [item] }

      it { is_expected.to be_truthy }
    end

    context "item does not exist in inventory" do
      let(:elements) { Concurrent::Array.new [] }

      it { is_expected.to be_falsey }
    end
  end
end
