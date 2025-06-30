require "rails_helper"

describe Chord do
  subject(:chord) { described_class.new(%w[G m 7 add4 B]) }

  describe "#initialize" do
    it "assigns all the chord parts to the correct variable" do
      expect(chord).to have_attributes(
        note: "G", type: "m", extension: "7", added_tone: "add4", bass_note: "B"
      )
    end
  end

  describe "#to_s" do
    it "returns all the chord parts joined together" do
      expect(chord.to_s).to eq "Gm7add4/B"
    end
  end

  describe "#length" do
    it "returns the length of all the chord parts joined" do
      expect(chord.length).to eq 9
    end
  end

  describe "#transpose" do
    it "returns a transposed instance of a chord" do
      expect(chord.transpose(:up).to_s).to eq "G#m7add4/C"
    end
  end
end
