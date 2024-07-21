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
  end
end
