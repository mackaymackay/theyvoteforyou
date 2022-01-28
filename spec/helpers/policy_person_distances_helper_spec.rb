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
        create(:member, person: person)
      end

      let(:person) { create(:person) }
      # We want a fixed id so we expect fixed url for the policy
      let(:policy) { create(:policy, id: 567, name: "dusty ponies being dusty") }

      context "when never voted" do
        let(:ppd) { create(:policy_person_distance, person: person, policy: policy) }

        it do
          expect(helper.policy_agreement_summary(ppd)).to eq "has never voted on"
        end

        it do
          expect(helper.policy_agreement_summary(ppd, with_person: true)).to eq "Christine Milne has never voted on"
        end

        it do
          expect(helper.policy_agreement_summary(ppd, with_person: true, link_person: true)).to eq '<a href="/people/representatives/newtown/christine_milne">Christine Milne</a> has never voted on'
        end

        it do
          expect(helper.policy_agreement_summary(ppd, with_person: true, link_category: true)).to eq 'Christine Milne <a href="/people/representatives/newtown/christine_milne/policies/567">has never voted on</a>'
        end

        it do
          expect(helper.policy_agreement_summary(ppd, with_person: true, with_policy: true)).to eq "Christine Milne has never voted on dusty ponies being dusty"
        end

        it do
          expect(helper.policy_agreement_summary(ppd, with_person: true, with_policy: true, link_policy: true)).to eq 'Christine Milne has never voted on <a href="/policies/567">dusty ponies being dusty</a>'
        end
      end

      context "when voted twice and distance is zero" do
        let(:ppd) { create(:policy_person_distance, person: person, policy: policy, distance_a: 0, nvotessame: 2) }

        it do
          expect(helper.policy_agreement_summary(ppd)).to eq "voted consistently for"
        end

        it do
          expect(helper.policy_agreement_summary(ppd, with_person: true)).to eq "Christine Milne voted consistently for"
        end
      end
    end
  end
end