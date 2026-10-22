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
      let(:user) { create(:user, sign_in_count: 1, created_at: 40.days.ago) }

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

  describe "#apply_styles_to_chord_sheets" do
    let(:user) { create(:user) }
    let(:styled) { create(:chord_sheet, user:, text_size: "larger") }

    before { create(:line_style, :chords, :red, styleable: styled) }

    it "keeps the styles for the user's new chord sheets" do
      user.apply_styles_to_chord_sheets(styled)

      expect([user.reload.text_size, user.line_styles.map { [it.line_type, it.colour] }])
        .to eq ["larger", [%w[chords red]]]
    end

    it "restyles the user's other chord sheets, replacing their styles" do
      other = create(:chord_sheet, user:)
      create(:line_style, :lyrics, :blue, styleable: other)

      user.apply_styles_to_chord_sheets(styled)

      expect([other.reload.text_size, other.line_styles.map { [it.line_type, it.colour] }])
        .to eq ["larger", [%w[chords red]]]
    end

    it "leaves other users' chord sheets alone" do
      someone_elses = create(:chord_sheet, user: create(:user))

      user.apply_styles_to_chord_sheets(styled)

      expect([someone_elses.reload.text_size, someone_elses.line_styles]).to eq ["normal", []]
    end
  end
end
