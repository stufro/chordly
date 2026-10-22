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

  describe "#content_style" do
    let(:chord_sheet) { create(:chord_sheet) }

    it "sizes the chord sheet's text" do
      chord_sheet.update!(text_size: "large")

      expect(helper.content_style(chord_sheet.reload)).to eq "font-size: 16px"
    end

    it "defaults to the normal text size" do
      expect(helper.content_style(chord_sheet)).to eq "font-size: 14px"
    end

    it "returns nil for a text size that isn't one of the options" do
      chord_sheet.text_size = "largest"

      expect(helper.content_style(chord_sheet)).to be_nil
    end
  end

  describe "#line_style" do
    let(:chord_sheet) { create(:chord_sheet) }

    it "returns the font style and colour CSS for a styled line type" do
      create(:line_style, :chords, :normal, :red, styleable: chord_sheet)

      expect(helper.line_style(chord_sheet.reload, { "type" => "chords" })).to eq "font-weight: normal; color: #e03131"
    end

    it "leaves out the colour when it's the default" do
      create(:line_style, :heading, :normal, styleable: chord_sheet)

      expect(helper.line_style(chord_sheet.reload, { "type" => "heading" })).to eq "font-weight: normal"
    end

    it "returns the default font style for an unstyled line type" do
      expect(helper.line_style(chord_sheet, { "type" => "lyrics" })).to eq "font-weight: normal"
    end

    it "sets italics without the bold a line type has by default" do
      create(:line_style, :chords, :italic, styleable: chord_sheet)

      line = { "type" => "chords" }

      expect(helper.line_style(chord_sheet.reload, line)).to eq "font-weight: normal; font-style: italic"
    end

    it "sizes headings relative to the rest of the chord sheet" do
      create(:line_style, :heading, :larger, styleable: chord_sheet)

      expect(helper.line_style(chord_sheet.reload, { "type" => "heading" })).to eq "font-weight: bold; font-size: 1.5em"
    end

    it "combines bold and italics" do
      create(:line_style, :lyrics, :bold_italic, styleable: chord_sheet)

      line = { "type" => "lyrics" }

      expect(helper.line_style(chord_sheet.reload, line)).to eq "font-weight: bold; font-style: italic"
    end
  end
end
