# frozen_string_literal: true

require "spec_helper"

describe PolicyPersonDistancesHelper, type: :helper do
  describe ".category_words" do
    it { expect(helper.category_words(:for3)).to eq "voted consistently for" }
    it { expect(helper.category_words(:never)).to eq "has never voted on" }
    it { expect(helper.category_words(:not_enough)).to eq "has not voted enough to determine a position on" }
  end

  describe ".policy_agreement_summary" do
    context "when user does not see the new policy category yet" do
      before do
        allow(helper).to receive(:current_user).and_return(nil)
      end

      context "when never voted" do
        let(:ppd) { create(:policy_person_distance) }

        it do
          expect(helper.policy_agreement_summary(ppd)).to eq "has never voted on"
        end
      end

      context "when voted twice and distance is zero" do
        let(:ppd) { create(:policy_person_distance, distance_a: 0, nvotessame: 2) }

        it do
          expect(helper.policy_agreement_summary(ppd)).to eq "voted consistently for"
        end
      end
    end
  end
end
