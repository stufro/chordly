require "rails_helper"

describe ChordSheet do
  describe ".not_deleted" do
    it "returns chord sheets which aren't deleted" do
      create(:chord_sheet, deleted: true)
      sheet1 = create(:chord_sheet, deleted: false)
      sheet2 = create(:chord_sheet, deleted: nil)

      expect(described_class.not_deleted).to contain_exactly(sheet1, sheet2)
    end
  end

  describe ".deleted" do
    it "returns chord sheets which aren't deleted" do
      sheet1 = create(:chord_sheet, deleted: true)
      create(:chord_sheet, deleted: false)

      expect(described_class.deleted).to contain_exactly(sheet1)
    end
  end

  describe "#transpose" do
    subject(:chord_sheet) { described_class.new(content: original_content) }

    let(:sheet_line) { instance_double SheetLine, :sheet_line }

    before do
      allow(SheetLine).to receive(:new).and_return sheet_line
    end

    context "with lyric lines" do
      let(:original_content) do
        [{ "type" => "lyrics", "content" => "Some song lyrics" }]
      end

      it "leaves them as they are" do
        allow(sheet_line).to receive(:chords?).and_return false

        chord_sheet.transpose(:up)
        expect(chord_sheet.content).to eq [sheet_line]
      end
    end

    context "with chord lines" do
      let(:original_content) do
        [{ "type" => "chords", "content" => "G   Am   C" }]
      end

      it "mutates the line with transposed chords" do
        allow(sheet_line).to receive_messages(chords?: true, transpose: :new_sheet_line)

        chord_sheet.transpose(:up)
        expect(chord_sheet.content).to eq [:new_sheet_line]
      end
    end
  end

  describe "#compact" do
    it "removes blank lines except those before a heading" do
      content = [
        { "type" => "heading", "content" => "[Verse]\r\n" },
        { "type" => "lyrics", "content" => "\r\n" },
        { "type" => "chords", "content" => "G   Am\r\n" },
        { "type" => "lyrics", "content" => "Verse lyrics\r\n" },
        { "type" => "lyrics", "content" => "\r\n" },
        { "type" => "lyrics", "content" => "\r\n" },
        { "type" => "heading", "content" => "[Chorus]\r\n" },
        { "type" => "lyrics", "content" => "Chorus lyrics\r\n" },
        { "type" => "lyrics", "content" => "\r\n" }
      ]
      chord_sheet = described_class.new(content:)

      chord_sheet.compact

      expect(chord_sheet.content).to eq [
        { "type" => "heading", "content" => "[Verse]\r\n" },
        { "type" => "chords", "content" => "G   Am\r\n" },
        { "type" => "lyrics", "content" => "Verse lyrics\r\n" },
        { "type" => "lyrics", "content" => "\r\n" },
        { "type" => "heading", "content" => "[Chorus]\r\n" },
        { "type" => "lyrics", "content" => "Chorus lyrics\r\n" }
      ]
    end

    it "removes a blank line before a heading at the top of the sheet" do
      content = [{ "type" => "lyrics", "content" => "\r\n" }, { "type" => "heading", "content" => "[Verse]\r\n" }]
      chord_sheet = described_class.new(content:)

      chord_sheet.compact

      expect(chord_sheet.content).to eq [{ "type" => "heading", "content" => "[Verse]\r\n" }]
    end
  end

  describe "#sections" do
    it "groups lines into sections ending at each blank line" do
      verse = [
        { "type" => "chords", "content" => "G   Am\r\n" },
        { "type" => "lyrics", "content" => "Verse lyrics\r\n" },
        { "type" => "lyrics", "content" => "\r\n" }
      ]
      chorus = [
        { "type" => "chords", "content" => "C   D\r\n" },
        { "type" => "lyrics", "content" => "Chorus lyrics" }
      ]
      chord_sheet = described_class.new(content: verse + chorus)

      expect(chord_sheet.sections).to eq [verse, chorus]
    end
  end

  describe "#unique_chords" do
    let(:content) do
      [
        { "type" => "chords", "content" => "G   Am7   C" },
        { "type" => "lyrics", "content" => "Some song lyrics" },
        { "type" => "chords", "content" => "G   Am7   Dsus4" }
      ]
    end

    it "returns an array of the chords included in the sheet" do
      chord_sheet = create(:chord_sheet, content:)
      expect(chord_sheet.unique_chords).to match_array %w[G Am7 C Dsus4]
    end

    context "when a chord line has annotations" do
      let(:content) do
        [
          { "type" => "chords", "content" => "G   Am7   C {some annotation}" },
          { "type" => "lyrics", "content" => "Some song lyrics" },
          { "type" => "chords", "content" => "G   Am7   Dsus4 [another annotation]" }
        ]
      end

      it "returns an array of the chords included in the sheet, ignoring annotations" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[G Am7 C Dsus4]
      end
    end

    context "when a chord line starts with a section label" do
      let(:content) do
        [
          { "type" => "chords", "content" => "Intro: G   Am7" },
          { "type" => "chords", "content" => "Verse 2 C" }
        ]
      end

      it "returns only the chords included in the sheet" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[G Am7 C]
      end
    end

    context "when a chord line has ignored characters" do
      let(:content) do
        [
          { "type" => "chords", "content" => "D |: D/F# :| G* N.C." }
        ]
      end

      it "returns only the chords included in the sheet" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[D D/F# G]
      end
    end

    context "when the same chord is written in different ways" do
      let(:content) do
        [
          { "type" => "chords", "content" => "g   em/b   F♯m   bb" },
          { "type" => "chords", "content" => "G   Em/B   F#m   Bb" }
        ]
      end

      it "returns each chord once in the spelling used by the chord diagrams" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[G Em/B F#m Bb]
      end
    end

    context "when a chord line contains something that isn't a chord" do
      let(:content) do
        [
          { "type" => "chords", "content" => "G   C7alt" }
        ]
      end

      it "returns it unchanged" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[G C7alt]
      end
    end

    context "when chords are separated by a slash" do
      let(:content) do
        [
          { "type" => "chords", "content" => "F/Am   G/B" }
        ]
      end

      it "returns each chord separately and keeps slash chords whole" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[F Am G/B]
      end
    end

    context "when bar lines have no spaces around them" do
      let(:content) do
        [
          { "type" => "chords", "content" => "|:G|Am:|*F|" }
        ]
      end

      it "returns each chord separately" do
        chord_sheet = create(:chord_sheet, content:)
        expect(chord_sheet.unique_chords).to match_array %w[G Am F]
      end
    end
  end

  describe "#line_style_for" do
    let(:chord_sheet) { create(:chord_sheet) }

    it "returns the saved style for the line type" do
      line_style = create(:line_style, :heading, styleable: chord_sheet)

      expect(chord_sheet.reload.line_style_for("heading")).to eq line_style
    end

    it "returns an unsaved style for a line type without one" do
      create(:line_style, :heading, styleable: chord_sheet)

      expect(chord_sheet.reload.line_style_for("chords")).to have_attributes(new_record?: true, line_type: "chords")
    end

    it "leaves the chord sheet's styles unchanged when falling back to a default" do
      create(:line_style, :heading, styleable: chord_sheet)
      chord_sheet.reload

      chord_sheet.line_style_for("chords")

      expect(chord_sheet.line_styles.map(&:line_type)).to eq ["heading"]
    end

    it "defaults chords and headings to bold and lyrics to normal" do
      font_styles = %w[chords heading lyrics].map { chord_sheet.line_style_for(it).font_style }

      expect(font_styles).to eq %w[bold bold normal]
    end
  end
end
