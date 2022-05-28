require "rails_helper"

describe ChordSheet do
  describe "#transpose" do
    subject { described_class.new(content: original_content) }

    let(:original_content) {[
      { "type" => "lyrics", "content" => "Some song lyrics" },
      { "type" => "chords", "content" => original_chords }
    ]}
    let(:original_chords) { "F Bb Dm" }
    let(:direction) { "up" }

    context "when the given direction is up" do
      let(:expected_chords) { "G♭5 C♭5 E♭m5" }

      it "increases all the chords by a semitone" do
        subject.transpose(:up)
        expect(subject.content[1].content).to eq(expected_chords)
      end
    end

    context "when the given direction is down" do
      let(:expected_chords) { "E5 A5 C#m5" }

      it "decreases all the chords by a semitone" do
        subject.transpose(:down)
        expect(subject.content[1].content).to eq(expected_chords)
      end
    end

    context "when there is whitespace between chords" do
      let(:original_chords) { " F  Bb   Dm" }
      let(:expected_chords) { " G♭5  C♭5   E♭m5" }

      it "maintains the whitespace" do
        subject.transpose(:up)
        expect(subject.content[1].content).to eq(expected_chords)
      end
    end 
  end
end