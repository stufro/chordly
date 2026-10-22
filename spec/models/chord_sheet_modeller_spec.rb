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

    context "when chords are separated by a slash" do
      let(:raw_content) do
        <<~TEXT
          F/Am
          I love, I love
        TEXT
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "F/Am\n" },
            { type: :lyrics, content: "I love, I love\n" }
          ]
        )
      end
    end

    context "when words are separated by a slash" do
      let(:raw_content) do
        <<~TEXT
          Bad/Good
        TEXT
      end

      it "models the line as lyrics" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :lyrics, content: "Bad/Good\n" }
          ]
        )
      end
    end

    context "when a line is blank" do
      let(:raw_content) { "G  Am\r\n\r\n   \r\n\u3000\r\nSome lyrics\r\n" }

      it "models the line as lyrics" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "G  Am\r\n" },
            { type: :lyrics, content: "\r\n" },
            { type: :lyrics, content: "   \r\n" },
            { type: :lyrics, content: "\u3000\r\n" },
            { type: :lyrics, content: "Some lyrics\r\n" }
          ]
        )
      end
    end

    context "when a line only contains bar lines, beat marks or N.C." do
      let(:raw_content) do
        <<~TEXT
          |    |    |
          |:  :|
          | . . . |
          N.C.
        TEXT
      end

      it "models the line as chords" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "|    |    |\n" },
            { type: :chords, content: "|:  :|\n" },
            { type: :chords, content: "| . . . |\n" },
            { type: :chords, content: "N.C.\n" }
          ]
        )
      end
    end

    context "when a line only contains bracketed text" do
      let(:raw_content) do
        <<~TEXT
          [Verse 1]
          {Chorus}
          | [Bridge] |
        TEXT
      end

      it "models the line as a heading" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :heading, content: "[Verse 1]\n" },
            { type: :heading, content: "{Chorus}\n" },
            { type: :heading, content: "| [Bridge] |\n" }
          ]
        )
      end
    end

    context "when a line is a section label without brackets" do
      let(:raw_content) do
        <<~TEXT
          Intro
          Verse 1:
          PRE-CHORUS
          Pre Chorus
          Prechorus
          Chorus x2
          Chorus (repeat)
          Repeat Chorus
          Post-chorus
          (Bridge)
          Middle 8
          Interlude 2x
          Instrumental
          Guitar Solo
          Breakdown
          Outro (x3)
          Coda
          Refrain
          Tag
        TEXT
      end

      it "models the line as a heading" do
        expect(described_class.new(raw_content).parse.pluck(:type)).to all(eq :heading)
      end
    end

    context "when a line starts with a section name followed by lyrics" do
      let(:raw_content) do
        <<~TEXT
          Bridge over troubled water
          Chorus girls are dancing
        TEXT
      end

      it "models the line as lyrics" do
        expect(described_class.new(raw_content).parse.pluck(:type)).to all(eq :lyrics)
      end
    end

    context "when a line starts with a section label followed by chords" do
      let(:raw_content) do
        <<~TEXT
          Intro: G C D
          Verse 1   Am   F
          (Chorus) G D
        TEXT
      end

      it "models the line as chords" do
        expect(described_class.new(raw_content).parse.pluck(:type)).to all(eq :chords)
      end
    end

    context "when a line contains bracketed text and chords" do
      let(:raw_content) do
        <<~TEXT
          [Intro] G  Am
        TEXT
      end

      it "models the line as chords" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :chords, content: "[Intro] G  Am\n" }
          ]
        )
      end
    end

    context "when a line contains bracketed text and lyrics" do
      let(:raw_content) do
        <<~TEXT
          Sing it [softly] now
        TEXT
      end

      it "models the line as lyrics" do
        expect(described_class.new(raw_content).parse).to eq(
          [
            { type: :lyrics, content: "Sing it [softly] now\n" }
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
