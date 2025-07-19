require "rails_helper"

describe ChordSheetModeller do
  describe "#parse" do
    let(:raw_content) do
      <<~TEXT
        G     Em    C
        Some lyrics here
      TEXT
    end

    it "returns the chord sheet string modelled as JSON" do
      expect(described_class.new(raw_content).parse).to eq(
        [
          { type: :chords, content: "G     Em    C\n" },
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
  end
end
