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
      let(:expected_content) {[
        { "type" => "lyrics", "content" => "Some song lyrics"},
        { "type" => "chords", "content" => "G♭5 C♭5 E♭m5"}
      ]}

      it "increases all the chords by a semitone" do
        subject.transpose(:up)
        expect(subject.content).to eq(expected_content)
      end
    end

    context "when there is whitespace between chords" do
      let(:original_chords) { " F  Bb   Dm" }
      let(:expected_content) {[
        { "type" => "lyrics", "content" => "Some song lyrics"},
        { "type" => "chords", "content" => " G♭5  C♭5   E♭m5"}
      ]}

      it "maintains the whitespace" do
        subject.transpose(:up)
        expect(subject.content).to eq(expected_content)
      end
    end 
  end
end