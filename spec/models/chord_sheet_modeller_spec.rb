require "rails_helper"

describe ChordSheetModeller do
  describe "#build" do
    let(:raw_content) {
      %Q(
 G     Em    C
Some lyrics here
      )
    }
    it "returns the chord sheet string modelled as JSON" do
      expect(described_class.new(raw_content).build).to eq([
        { type: :chords, content: " G     Em    C"},
        { type: :lyrics, content: "Some lyrics here"},
      ])
    end
  end
end