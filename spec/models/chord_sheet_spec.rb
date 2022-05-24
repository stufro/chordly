require "rails_helper"

describe ChordSheet do
  describe "#transpose" do
    subject { described_class.new(content: original_content) }

    let(:original_content) {[
      { "type" => "chords", "content" => "F Bb Dm" },
      { "type" => "lyrics", "content" => "Some song lyrics" }
    ]}

    context "when the given direction is up" do
      let(:direction) { "up" }
      let(:expected_content) {[
        { "type" => "chords", "content" => "G♭5 C♭5 E♭m5"},
        { "type" => "lyrics", "content" => "Some song lyrics"}
      ]}

      it "increases all the chords by a semitone" do
        subject.transpose(:up)
        expect(subject.content).to eq(expected_content)
      end
    end
  end
end