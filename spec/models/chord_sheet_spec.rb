# frozen_string_literal: true

require "rails_helper"

describe ChordSheet do
  describe "#transpose" do
    subject(:chord_sheet) { described_class.new(content: original_content) }

    let(:original_content) do
      [
        { "type" => "lyrics", "content" => "Some song lyrics" },
        { "type" => "chords", "content" => original_chords }
      ]
    end
    let(:original_chords) { "F Bb Dm" }
    let(:direction) { "up" }

    context "when the given direction is up" do
      let(:expected_chords) { "F# B D#m" }

      it "increases all the chords by a semitone" do
        chord_sheet.transpose(:up)
        expect(chord_sheet.content[1].content).to eq(expected_chords)
      end
    end

    context "when the given direction is down" do
      let(:expected_chords) { "E A C#m" }

      it "decreases all the chords by a semitone" do
        chord_sheet.transpose(:down)
        expect(chord_sheet.content[1].content).to eq(expected_chords)
      end
    end

    context "when there is whitespace between chords" do
      let(:original_chords) { " F  Bb   Dm" }
      let(:expected_chords) { " F#  B   D#m" }

      it "maintains the whitespace" do
        chord_sheet.transpose(:up)
        expect(chord_sheet.content[1].content).to eq(expected_chords)
      end
    end
  end
end
