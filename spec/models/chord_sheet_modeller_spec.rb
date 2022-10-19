require "rails_helper"

describe ChordSheetModeller do
  describe "#parse" do
    let(:raw_content) do
      %( G     Em    C
Some lyrics here)
    end

    it "returns the chord sheet string modelled as JSON" do
      expect(described_class.new(raw_content).parse).to eq([
                                                             { type: :chords, content: " G     Em    C\n" },
                                                             { type: :lyrics, content: "Some lyrics here" }
                                                           ])
    end

    context "when the chords are lower case" do
      let(:raw_content) do
        %( g     em    c
Some lyrics here)
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq([
                                                               { type: :chords, content: " g     em    c\n" },
                                                               { type: :lyrics, content: "Some lyrics here" }
                                                             ])
      end
    end

    context "when the chords contain bar lines" do
      let(:raw_content) do
        %(G    |  Em   D |
|: Am  | F  :|)
      end

      it "returns the chord sheet string modelled as JSON" do
        expect(described_class.new(raw_content).parse).to eq([
                                                               { type: :chords, content: "G    |  Em   D |\n" },
                                                               { type: :chords, content: "|: Am  | F  :|" }
                                                             ])
      end
    end
  end
end
