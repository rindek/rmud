# frozen_string_literal: true
RSpec.describe Engine::Actions::Wield do
  let(:action) { described_class.new }

  subject { action.call(weapon: weapon, player: player) }

  let(:player) { FactoryBot.create(:game_player) }

  context "wielding one-handed weapon" do
    let(:weapon) { FactoryBot.create(:weapon) }

    context "both hands empty" do
      it "pre-check - both hands empty" do
        expect(player.slots.slice(:right_hand, :left_hand)).to eq(right_hand: M.None, left_hand: M.None)
      end

      it "returns success" do
        expect(subject).to be_success
      end

      it "occupies right hand slot" do
        expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
          right_hand: M.Some(weapon),
          left_hand: M.None,
        )
      end

      context "already wielding this weapon" do
        before { player.slots[:right_hand] = M.Some(weapon) }
        it "returns failure with proper message" do
          expect(subject).to cause(:already_wielding)
        end
      end
    end

    context "already wielding one-handed weapon in right hand" do
      let(:wielding_weapon) { FactoryBot.create(:weapon) }
      before { player.slots[:right_hand] = M.Some(wielding_weapon) }

      it "returns success" do
        expect(subject).to be_success
      end

      it "occupies left hand slot" do
        expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
          right_hand: M.Some(wielding_weapon),
          left_hand: M.Some(weapon),
        )
      end
    end

    context "already wielding one-handed weapon in left hand" do
      let(:wielding_weapon) { FactoryBot.create(:weapon) }
      before { player.slots[:left_hand] = M.Some(wielding_weapon) }

      it "returns success" do
        expect(subject).to be_success
      end

      it "occupies left hand slot" do
        expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
          right_hand: M.Some(weapon),
          left_hand: M.Some(wielding_weapon),
        )
      end
    end

    context "both hands are full" do
      context "wielding two one-handed weapons" do
        let(:wielding_weapon1) { FactoryBot.create(:weapon) }
        let(:wielding_weapon2) { FactoryBot.create(:weapon) }

        before do
          player.slots[:right_hand] = M.Some(wielding_weapon1)
          player.slots[:left_hand] = M.Some(wielding_weapon2)
        end

        it "returns failure with proper message" do
          expect(subject).to cause(:need_one_hand_empty)
        end
      end

      context "wielding two-handed weapon" do
        let(:wielding_weapon) { FactoryBot.create(:weapon, :two_hand) }

        before do
          player.slots[:right_hand] = M.Some(wielding_weapon)
          player.slots[:left_hand] = M.Some(wielding_weapon)
        end

        it "returns failure with proper message" do
          expect(subject).to cause(:need_one_hand_empty)
        end
      end
    end
  end

  context "wielding two-handed weapon" do
    let(:weapon) { FactoryBot.create(:weapon, :two_hand) }

    context "both hands empty" do
      it "pre-check - both hands empty" do
        expect(player.slots.slice(:right_hand, :left_hand)).to eq(right_hand: M.None, left_hand: M.None)
      end

      it "returns success" do
        expect(subject).to be_success
      end

      it "occupies both hand slot" do
        expect { subject }.to change { player.slots.slice(:right_hand, :left_hand) }.to(
          right_hand: M.Some(weapon),
          left_hand: M.Some(weapon),
        )
      end

      context "already wielding this weapon" do
        before do
          player.slots[:right_hand] = M.Some(weapon)
          player.slots[:left_hand] = M.Some(weapon)
        end

        it "returns failure with proper message" do
          expect(subject).to cause(:already_wielding)
        end
      end
    end

    context "both hands are full" do
      context "wielding two one-handed weapons" do
        let(:wielding_weapon1) { FactoryBot.create(:weapon) }
        let(:wielding_weapon2) { FactoryBot.create(:weapon) }

        before do
          player.slots[:right_hand] = M.Some(wielding_weapon1)
          player.slots[:left_hand] = M.Some(wielding_weapon2)
        end

        it "returns failure with proper message" do
          expect(subject).to cause(:need_both_hands_empty)
        end
      end

      context "wielding two-handed weapon" do
        let(:wielding_weapon) { FactoryBot.create(:weapon, :two_hand) }

        before do
          player.slots[:right_hand] = M.Some(wielding_weapon)
          player.slots[:left_hand] = M.Some(wielding_weapon)
        end

        it "returns failure with proper message" do
          expect(subject).to cause(:need_both_hands_empty)
        end
      end
    end
  end
end
