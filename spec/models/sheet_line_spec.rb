# frozen_string_literal: true

require "rails_helper"

describe SheetLine do
  describe "#initialize" do
    subject(:sheet_line) { described_class.new(line) }

    let(:line) { { "type" => "chords", "content" => "Some content" } }

    it "assigns the type from the given hash" do
      expect(sheet_line.type).to eq "chords"
    end

    it "assigns the content from the given hash" do
      expect(sheet_line.content).to eq "Some content"
    end
  end

  describe "#transpose" do
    subject(:sheet_line) { described_class.new(line) }

    let(:line) do
      { "type" => "chords", "content" => original_chords }
    end
    let(:original_chords) { "F Bb Dm" }
    let(:direction) { "up" }

    context "when the given direction is up" do
      let(:expected_chords) { "F# B D#m" }

      it "increases all the chords by a semitone" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the given direction is down" do
      let(:expected_chords) { "E A C#m" }

      it "decreases all the chords by a semitone" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there is whitespace between chords" do
      let(:original_chords) { " F  Bb   Dm" }
      let(:expected_chords) { " F#  B   D#m" }

      it "maintains the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the chords are lower case" do
      let(:original_chords) { " f  bb   dm" }
      let(:expected_chords) { " F#  B   D#m" }

      it "maintains the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there is an invalid chord in the line" do
      let(:original_chords) { " F   Bb   H" }
      let(:expected_chords) { " F#   B   H" }

      it "ignores the invalid chord" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end
  end
end
