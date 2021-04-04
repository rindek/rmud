# frozen_string_literal: true
RSpec.describe Repos::Mongo do
  class FakeEntityForTests < Dry::Struct
    attribute :id, Types::BSON
    attribute :name, Types::String
  end

  let!(:klass) { Class.new(described_class).new(dataset: collection, entity: FakeEntityForTests) }
  let(:collection) { App[:mongo][:test_collection] }

  let(:repo) { described_class.new }

  let(:some) { subject.value! }

  before do
    collection.insert_one({ name: "first" })
    collection.insert_one({ name: "second" })
  end

  describe "#first" do
    subject { klass.first }

    it "returns first found document in collection" do
      expect(some).to be_a(FakeEntityForTests)
      expect(some.name).to eq("first")
    end

    context "when collection is empty" do
      before { collection.delete_many }

      it "returns None" do
        expect(subject).to be_a(M::None)
      end
    end
  end

  describe "#find_by" do
    subject { klass.find_by(args) }

    describe "document exists" do
      let(:args) { { name: "second" } }

      it "finds and returns document wrapped in entity" do
        expect(some).to be_a(FakeEntityForTests)
        expect(some.name).to eq("second")
      end
    end

    describe "document not found" do
      let(:args) { { name: "not found" } }

      it "returns None" do
        expect(subject).to be_a(M::None)
      end
    end
  end

  describe "#all_by" do
    subject { klass.all_by(args) }

    describe "given no args" do
      let(:args) { {} }

      it "finds and returns all documents wrapped in entity" do
        expect(some.count).to eq(2)
        expect(some).to be_all(FakeEntityForTests)
      end
    end

    describe "document exists" do
      let(:args) { { name: "second" } }

      it "finds and returns documents wrapped in entity" do
        expect(some.count).to eq(1)
        expect(some[0]).to be_a(FakeEntityForTests)
        expect(some[0].name).to eq("second")
      end
    end

    describe "documents not found" do
      let(:args) { { name: "not found" } }

      it "returns None" do
        expect(subject).to be_a(M::None)
      end
    end
  end

  describe "#each" do
    it "yields block for each wrapped entity" do
      expect { |b| klass.each(&b) }.to yield_control
    end
  end
end
