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
