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
    let(:original_chords) { "F  Bb Dm" }
    let(:direction) { "up" }

    context "when the given direction is up" do
      let(:expected_chords) { "F# B  D#m" }

      it "increases all the chords by a semitone" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the given direction is down" do
      let(:original_chords) { "G  Am  D" }
      let(:expected_chords) { "F# G#m C#" }

      it "decreases all the chords by a semitone" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the chords follow a section label" do
      let(:original_chords) { "Pre-chorus 2: G  Am" }
      let(:expected_chords) { "Pre-chorus 2: G# A#m" }

      it "leaves the label unchanged" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there is whitespace between chords" do
      let(:original_chords) { " F  Bb   Dm" }
      let(:expected_chords) { " F# B    D#m" }

      it "maintains the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the chords are lower case" do
      let(:original_chords) { " f  bb   dm" }
      let(:expected_chords) { " F# B    D#m" }

      it "maintains the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there is an invalid chord in the line" do
      let(:original_chords) { " F   Bb   H" }
      let(:expected_chords) { " F#  B    H" }

      it "ignores the invalid chord" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there are chord a semitone apart in the original chords" do
      let(:original_chords) { " G   G#m   Asus   G" }
      let(:expected_chords) { " G#  Am    A#sus  G#" }

      it "transposes correctly" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there are chord inversions transposing up" do
      let(:original_chords) { " G/D   G#m   Asus   G" }
      let(:expected_chords) { " G#/D# Am    A#sus  G#" }

      it "transposes the chord and the bass note and maintains the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there are chord inversions transposing down" do
      let(:original_chords) { " G#/D# Am    A#sus  G#" }
      let(:expected_chords) { " G/D   G#m   Asus   G " }

      it "transposes the chord and the bass note and maintains the whitespace" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there is not enough whitespace to available to substitute the chord into" do
      let(:original_chords) { " G/D G#m   Asus G " }
      let(:expected_chords) { " G#/D# Am    A#sus G#" }

      it "doesn't adjust the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when there are bar lines in the chords" do
      let(:original_chords) { "|: G  |  Am  |  D :|" }
      let(:expected_chords) { "|: F# |  G#m |  C# :|" }

      it "transposes the chords and leaves the chord lines in place" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when bar lines have no spaces around them" do
      let(:original_chords) { "|:G|Am:|*F|" }
      let(:expected_chords) { "|:G#|A#m:|*F#|" }

      it "transposes the chords and leaves the bar lines in place" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with suspended, extended and altered chords" do
      let(:original_chords) { "G7sus4  Cm7b5  E7#9  G6/9/B" }
      let(:expected_chords) { "G#7sus4 C#m7b5 F7#9  G#6/9/C" }

      it "transposes the root and bass notes and keeps the rest of the chord" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with chord symbols" do
      let(:original_chords) { "C+  C°7  Cø7  CM7" }
      let(:expected_chords) { "B+  B°7  Bø7  BM7" }

      it "transposes the root and keeps the symbol" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with musical accidental symbols" do
      let(:original_chords) { "F♯  C♯m  B♭  D/F♯" }
      let(:expected_chords) { "G   Dm   B   D#/G" }

      it "transposes the chords and maintains the whitespace" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the chords contain dots" do
      let(:original_chords) { "| A . . | E/G# . . | C." }
      let(:expected_chords) { "| A# . . | F/A  . . | C#." }

      it "transposes the chords and leaves the dots in place" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when the chords are followed by a repeat marker" do
      let(:original_chords) { "D G x3 A 2x" }
      let(:expected_chords) { "D# G# x3 A# 2x" }

      it "transposes the chords and leaves the repeat markers unchanged" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when chords are in brackets" do
      let(:original_chords) { "(D7)  G  (D)" }
      let(:expected_chords) { "(D#7)  G# (D#)" }

      it "transposes the chords and leaves the brackets in place" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when chords are separated by a slash" do
      let(:original_chords) { "F/Am  C" }
      let(:expected_chords) { "F#/A#m C#" }

      it "transposes each chord" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with add4 chords" do
      let(:original_chords) { "Gadd4  Amadd2  Dadd9" }
      let(:expected_chords) { "F#add4 G#madd2 C#add9" }

      it "transposes the chords correctly" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with sharp add4 chords" do
      let(:original_chords) { "F#add4  G#madd2  C#add9" }
      let(:expected_chords) { "Fadd4   Gmadd2   Cadd9 " }

      it "transposes the chords correctly" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with a N.C. chord" do
      let(:original_chords) { "G Em D N.C." }
      let(:expected_chords) { "F# D#m C# N.C." }

      it "transposes the chords and leaves the N.C. in place" do
        sheet_line.transpose(:down)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with nashville numbers" do
      let(:original_chords) { "1 2 3 Gm" }
      let(:expected_chords) { "1 2 3 G#m" }

      it "does not transpose nashville numbers" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with bracketed content" do
      let(:original_chords) { "F [Foo] Bb Dm  {Verse 1}" }
      let(:expected_chords) { "F# [Foo] B  D#m {Verse 1}" }

      it "ignores the content" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a square bracketed label contains a chord letter" do
      let(:original_chords) { "[Chorus] C" }
      let(:expected_chords) { "[Chorus] C#" }

      it "leaves the label unchanged" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a curly bracketed label contains a chord letter" do
      let(:original_chords) { "{Bridge} B" }
      let(:expected_chords) { "{Bridge} C" }

      it "leaves the label unchanged" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a label between chords contains a later chord's letter" do
      let(:original_chords) { "G [Fade] F" }
      let(:expected_chords) { "G# [Fade] F#" }

      it "leaves the label unchanged" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a label contains the same chord as the line" do
      let(:original_chords) { "[Am riff] Am" }
      let(:expected_chords) { "[Am riff] A#m" }

      it "only transposes the chord outside the label" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a chord follows N.C." do
      let(:original_chords) { "N.C. C" }
      let(:expected_chords) { "N.C. C#" }

      it "leaves the N.C. unchanged" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when bracketed text splits a chord" do
      let(:original_chords) { "G[x]m" }
      let(:expected_chords) { "G#[x]m" }

      it "transposes the chord before the brackets" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with minor major chords" do
      let(:original_chords) { "Cmmaj7  Dmmaj7/A" }
      let(:expected_chords) { "C#mmaj7 D#mmaj7/A#" }

      it "transposes the whole chord" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "with a chord that isn't fully recognised" do
      let(:original_chords) { "G  C7alt  D" }
      let(:expected_chords) { "G# C7alt  D#" }

      it "leaves it unchanged rather than transposing part of it" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a lengthened chord ends the line" do
      let(:original_chords) { "Am   F\r\n" }
      let(:expected_chords) { "A#m  F#\r\n" }

      it "keeps the line ending" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end

    context "when a lengthened chord is followed by trailing spaces and a line ending" do
      let(:original_chords) { "Am G/D \r\n" }
      let(:expected_chords) { "A#m G#/D#\r\n" }

      it "absorbs the trailing spaces and keeps the line ending" do
        sheet_line.transpose(:up)
        expect(sheet_line.content).to eq(expected_chords)
      end
    end
  end
end
