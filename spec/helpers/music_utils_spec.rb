require_relative "../../app/helpers/music_utils"

describe MusicUtils do
  subject(:music_utils) { Class.new { extend MusicUtils } }

  describe "#extract_note" do
    it "returns the note from the given chords" do
      chord = "C#m7"
      expect(music_utils.extract_note(chord)).to eq "C#"
    end

    context "when there is not a valid note in the string" do
      it "returns the given input" do
        not_a_chord = "Another string"
        expect(music_utils.extract_note(not_a_chord)).to eq not_a_chord
      end
    end

    context "with some different chord types" do
      it "returns the root note" do
        %w[Bbmaj Bb5 Bb7 Bbm5 Bbm7 Bbmin7 Bbmin Bbsus4 Bbsus2 Bb9 Bbm9 Bb13 Bbm13].each do |chord|
          expect(music_utils.extract_note(chord)).to eq "Bb"
        end
      end
    end

    context "with an inversion" do
      it "returns the root note" do
        expect(music_utils.extract_note("G#/D#")).to eq "G#"
      end
    end
  end

  describe "#extract_note!" do
    it "returns the note from the given chords" do
      chord = "Am"
      expect(music_utils.extract_note!(chord)).to eq "A"
    end

    context "when an invalid chord is given" do
      it "raises an ArgumentError exception" do
        not_a_chord = "Another string"
        expect { music_utils.extract_note!(not_a_chord) }.to raise_exception(ArgumentError)
      end
    end
  end
end
