require "rails_helper"

describe LineStyle do
  it "allows one style per line type for each chord sheet" do
    existing = create(:line_style, :chords)
    duplicate = build(:line_style, :chords, styleable: existing.styleable)

    expect(duplicate).not_to be_valid
  end
end
