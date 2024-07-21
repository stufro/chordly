require "rails_helper"

RSpec.describe User do
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
