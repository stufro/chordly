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
        %w[Bbmaj Bb5 Bb7 Bbm5 Bbm6 Bbmaj6 Bbm7 Bbmin7 Bbmin Bbsus4 Bbsus2 Bb9 Bbm9 Bb13 Bbm13 Bbmmaj7
           Bbm7add4 Bbadd4].each do |chord|
          expect(music_utils.extract_note(chord)).to eq "Bb"
        end
      end
    end

    context "with suspended, extended and altered chords" do
      it "returns the root note" do
        %w[G7sus4 G9sus4 G7sus2 G11 Gm11 Gmaj7#11 Gm7b5 G7#9 G7b9 G7♭9 G7#5 G7+5 G7+9 Gmaj13 G6/9 G69
           G6/9/B].each do |chord|
          expect(music_utils.extract_note(chord)).to eq "G"
        end
      end
    end

    context "with chord symbols" do
      it "returns the root note" do
        %w[G+ G+7 G°7 Gø7 GM7].each do |chord|
          expect(music_utils.extract_note(chord)).to eq "G"
        end
      end
    end

    context "with musical accidental symbols" do
      it "returns the root note" do
        { "F♯m7" => "F♯", "B♭maj7" => "B♭", "D/F♯" => "D" }.each do |chord, root_note|
          expect(music_utils.extract_note(chord)).to eq root_note
        end
      end
    end

    context "with an inversion" do
      it "returns the root note" do
        expect(music_utils.extract_note("G#/D#")).to eq "G#"
      end
    end

    context "with the nashville number system" do
      it "returns the root note" do
        expect(music_utils.extract_note("1m")).to eq "1"
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

    context "when an alteration has no number" do
      it "raises an ArgumentError exception" do
        expect { music_utils.extract_note!("G7#") }.to raise_exception(ArgumentError)
      end
    end
  end

  describe "#chord_tokens" do
    it "returns the whitespace separated tokens in the line" do
      expect(music_utils.chord_tokens("G　 Am\tC\r\n")).to eq %w[G Am C]
    end

    it "treats bar lines, repeat colons and asterisks as separators" do
      expect(music_utils.chord_tokens("|:G|Am:|*F|")).to eq %w[G Am F]
    end

    it "treats dots as separators" do
      expect(music_utils.chord_tokens("| A . . . | E/G# . . . | C.")).to eq %w[A E/G# C]
    end

    it "ignores N.C. next to dots" do
      expect(music_utils.chord_tokens("G. N.C. . D")).to eq %w[G D]
    end

    it "ignores repeat markers" do
      expect(music_utils.chord_tokens("D x3 G 2x A ×4 E X2")).to eq %w[D G A E]
    end

    it "keeps tokens that only look like part of a repeat marker" do
      expect(music_utils.chord_tokens("D x G x3x")).to eq %w[D x G x3x]
    end

    it "removes brackets around tokens" do
      expect(music_utils.chord_tokens("(D7) G (D) (G  A)")).to eq %w[D7 G D G A]
    end

    it "ignores bracketed repeat markers" do
      expect(music_utils.chord_tokens("D G (x2)")).to eq %w[D G]
    end

    it "splits tokens of chords separated by slashes" do
      expect(music_utils.chord_tokens("F/Am C/G/E")).to eq %w[F Am C G E]
    end

    it "keeps slash chords whole" do
      expect(music_utils.chord_tokens("G/B D/F#")).to eq %w[G/B D/F#]
    end

    it "keeps slash separated tokens that aren't all chords" do
      expect(music_utils.chord_tokens("and/or F/ /F")).to eq %w[and/or F/ /F]
    end

    it "ignores N.C. and text in {} or []" do
      expect(music_utils.chord_tokens("G N.C. {some text} Em [more text] D")).to eq %w[G Em D]
    end
  end
end
