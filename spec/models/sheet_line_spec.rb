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
  end
end
