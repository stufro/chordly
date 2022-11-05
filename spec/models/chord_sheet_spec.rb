require "rails_helper"

describe ChordSheet do
  describe ".for_user" do
    it "returns the sheets which belong to the given user" do
      create(:chord_sheet)
      user = create(:user, email: "b@b.com")
      wanted_sheet = create(:chord_sheet, user:)

      expect(described_class.for_user(user)).to eq [wanted_sheet]
    end
  end

  describe ".not_deleted" do
    it "returns chord sheets which aren't deleted" do
      create(:chord_sheet, deleted: true)
      sheet1 = create(:chord_sheet, deleted: false)
      sheet2 = create(:chord_sheet, deleted: nil)

      expect(described_class.not_deleted).to match_array [sheet1, sheet2]
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
        allow(sheet_line).to receive(:chords?).and_return true
        allow(sheet_line).to receive(:transpose).and_return :new_sheet_line

        chord_sheet.transpose(:up)
        expect(chord_sheet.content).to eq [:new_sheet_line]
      end
    end
  end
end
