require "rails_helper"

describe Chord do
  subject { described_class.new(["G", "m", "7", "B"]) }

  describe "#initialize" do
    it "assigns all the chord parts to the correct variable" do
      expect(subject).to have_attributes(
        note: "G", type: "m", extension: "7", bass_note: "B"
      )
    end
  end

  describe "#to_s" do
    it "returns all the chord parts joined together" do
      expect(subject.to_s).to eq "Gm7/B"
    end
  end

  describe "#length" do
    it "returns the length of all the chord parts joined" do
      expect(subject.length).to eq 5
    end
  end
  
  describe "#transpose" do
    it "returns a transposed instance of a chord" do
      expect(subject.transpose(:up).to_s).to eq "G#m7/C"
    end
  end
end