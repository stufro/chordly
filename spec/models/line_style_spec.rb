require "rails_helper"

describe LineStyle do
  it "only allows a font size on headings" do
    expect(build(:line_style, :lyrics, font_size: "larger")).not_to be_valid
  end
end
