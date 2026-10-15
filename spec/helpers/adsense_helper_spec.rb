require "rails_helper"

describe AdsenseHelper do
  describe "#adsense_unit" do
    it "renders an ad unit for visitors" do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      expect(helper.adsense_unit(:horizontal)).to include "adsbygoogle"
    end

    it "renders an ad unit for standard users" do
      allow(helper).to receive_messages(user_signed_in?: true, current_user: build(:user, :standard))
      expect(helper.adsense_unit(:horizontal)).to include "adsbygoogle"
    end

    it "renders nothing for ad-free users" do
      allow(helper).to receive_messages(user_signed_in?: true, current_user: build(:user, :ad_free))
      expect(helper.adsense_unit(:horizontal)).to be_nil
    end
  end
end
