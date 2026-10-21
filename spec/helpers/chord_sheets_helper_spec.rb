require "rails_helper"

describe ChordSheetsHelper do
  describe "#line_class" do
    it "returns the chord line class for chord lines" do
      expect(helper.line_class({ "type" => "chords", "content" => "G  Am" })).to eq "chord-line"
    end

    it "returns the heading line class for headings" do
      expect(helper.line_class({ "type" => "heading", "content" => "[Verse 1]" })).to eq "heading-line"
    end

    it "returns the lyric line class for lyric lines" do
      expect(helper.line_class({ "type" => "lyrics", "content" => "Some lyrics" })).to eq "lyric-line"
    end
  end
end
