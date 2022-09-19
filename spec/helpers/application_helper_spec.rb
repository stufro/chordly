require "rails_helper"

describe ApplicationHelper, type: :helper do
  describe "#format_datetime" do
    it "formats the datetime" do
      datetime = Time.new(2022, 2, 4, 14, 58).utc
      expect(format_datetime(datetime)).to eq "2022-02-04 14:58"
    end

    it "returns an empty string when the given date is nil" do
      expect(format_datetime(nil)).to eq ""
    end
  end
end
