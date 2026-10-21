require "rails_helper"

describe ChordSheetModeller do
  describe "#parse" do
    let(:raw_content) do
      <<~TEXT
        Gsus4     Em    C/E
        Some lyrics here
      TEXT
    end

    it "returns the chord sheet string modelled as JSON" do
      expect(described_class.new(raw_content).parse).to eq(
        [
          { type: :chords, content: "Gsus4     Em    C/E\n" },
          { type: :lyrics, content: "Some lyrics here\n" }
        ]
      )
    end

    context "when the chords are lower case" do
      let(:raw_content) do
        <<~TEXT
          g     em    c
          Some lyrics here
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "g     em    c\n" },
            { type: :lyrics, content: "Some lyrics here\n" }
          ]
        )
      end
    end

    context "when the chords contain bar lines" do
      let(:raw_content) do
        <<~TEXT
          G    |  Em   D |
          |: Am  | F  :|
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "G    |  Em   D |\n" },
            { type: :chords, content: "|: Am  | F  :|\n" }
          ]
        )
      end
    end

    context "when the bar lines have no spaces around them" do
      let(:raw_content) do
        <<~TEXT
          |G|Am|F|C|
          |:G|Am:|
          G*|Am*|
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "|G|Am|F|C|\n" },
            { type: :chords, content: "|:G|Am:|\n" },
            { type: :chords, content: "G*|Am*|\n" }
          ]
        )
      end
    end

    context "when words are joined by bar lines" do
      let(:raw_content) do
        <<~TEXT
          Go|Away
        TEXT
      end

      it "models the line as lyrics" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :lyrics, content: "Go|Away\n" }
          ]
        )
      end
    end

    context "when the chords use musical accidental symbols" do
      let(:raw_content) do
        <<~TEXT
          F♯  C♯m  B♭  D/F♯
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "F♯  C♯m  B♭  D/F♯\n" }
          ]
        )
      end
    end

    context "when the chords are suspended, extended or altered" do
      let(:raw_content) do
        <<~TEXT
          G7sus4  C11  Cm7b5  E7#9  G6/9/B
          C+  C°7  Cø7  CM7
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "G7sus4  C11  Cm7b5  E7#9  G6/9/B\n" },
            { type: :chords, content: "C+  C°7  Cø7  CM7\n" }
          ]
        )
      end
    end

    context "when the chords contain dots" do
      let(:raw_content) do
        <<~TEXT
          C.           G
          | A . . . . . | E/G# . . . . . |
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "C.           G\n" },
            { type: :chords, content: "| A . . . . . | E/G# . . . . . |\n" }
          ]
        )
      end
    end

    context "when the chords are followed by a repeat marker" do
      let(:raw_content) do
        <<~TEXT
          D G A G A G x3
          D G 2x
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "D G A G A G x3\n" },
            { type: :chords, content: "D G 2x\n" }
          ]
        )
      end
    end

    context "when chords are in brackets" do
      let(:raw_content) do
        <<~TEXT
          (D7)        G        Bm             Bb            D
          G           Bm              Bb             (D)
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "(D7)        G        Bm             Bb            D\n" },
            { type: :chords, content: "G           Bm              Bb             (D)\n" }
          ]
        )
      end
    end

    context "when part of a chord is in brackets" do
      let(:raw_content) do
        <<~TEXT
          G  C7(b9)
        TEXT
      end

      it "models the line as lyrics" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :lyrics, content: "G  C7(b9)\n" }
          ]
        )
      end
    end

    context "when the chords contain asterisks" do
      let(:raw_content) do
        <<~TEXT
          G Em D*
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "G Em D*\n" }
          ]
        )
      end
    end

    context "when the chords contain N.C." do
      let(:raw_content) do
        <<~TEXT
          G Em D N.C.
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "G Em D N.C.\n" }
          ]
        )
      end
    end

    context "when the chords contain text in [] or {}" do
      let(:raw_content) do
        <<~TEXT
          G {some text} Em [more text] D
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "G {some text} Em [more text] D\n" }
          ]
        )
      end
    end

    context "when the chords are separated by ideographic spaces" do
      let(:raw_content) { "Am　　　F\r\n" }

      it "replaces each ideographic space with two spaces to keep the chords aligned" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "Am      F\r\n" }
          ]
        )
      end
    end

    context "when lyrics contain ideographic spaces" do
      let(:raw_content) { "君の　名は\r\n" }

      it "leaves the lyrics unchanged" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :lyrics, content: "君の　名は\r\n" }
          ]
        )
      end
    end
  end
end
