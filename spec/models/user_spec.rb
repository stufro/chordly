require "rails_helper"

RSpec.describe User do
  describe "#show_support_toast?" do
    subject { user.show_support_toast? }

    context "when the user meets all criteria" do
      let(:user) { create(:user, sign_in_count: 5, created_at: 40.days.ago) }

      it { is_expected.to be true }
    end

    context "when the account is less than 1 month old" do
      let(:user) { create(:user, sign_in_count: 5, created_at: 2.days.ago) }

      it { is_expected.to be false }
    end

    context "when sign_in_count is below the threshold" do
      let(:user) { create(:user, sign_in_count: 4, created_at: 40.days.ago) }

      it { is_expected.to be false }
    end

    context "when the toast was dismissed less than 3 months ago" do
      let(:user) { create(:user, sign_in_count: 5, created_at: 40.days.ago, support_toast_dismissed_at: 1.month.ago) }

      it { is_expected.to be false }
    end

    context "when the toast was dismissed more than 3 months ago" do
      let(:user) { create(:user, sign_in_count: 5, created_at: 40.days.ago, support_toast_dismissed_at: 4.months.ago) }

      it { is_expected.to be true }
    end

    context "when the toast was never dismissed" do
      let(:user) { create(:user, sign_in_count: 5, created_at: 40.days.ago, support_toast_dismissed_at: nil) }

      it { is_expected.to be true }
    end
  end

  describe "#deleted_content?" do
    it "returns true if the user has deleted chord sheets" do
      user = create(:user)
      create(:chord_sheet, user:, deleted: true)

      expect(user.deleted_content?).to be true
    end

    it "returns true if the user has deleted set lists" do
      user = create(:user)
      create(:set_list, user:, deleted: true)

      expect(user.deleted_content?).to be true
    end
  end
end
