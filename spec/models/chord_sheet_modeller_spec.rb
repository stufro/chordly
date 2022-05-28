# frozen_string_literal: true

require "rails_helper"

describe ChordSheetModeller do
  describe "#parse" do
    let(:raw_content) do
      %(
 G     Em    C
Some lyrics here
      )
    end

    it "returns the chord sheet string modelled as JSON" do
      expect(described_class.new(raw_content).parse).to eq([
                                                             { type: :chords, content: " G     Em    C" },
                                                             { type: :lyrics, content: "Some lyrics here" }
                                                           ])
    end

    context "when there are empty lines" do
      let(:raw_content) do
        %(

 G     Em    C
Some lyrics here
        )
      end

      it "removes them" do
        expect(described_class.new(raw_content).parse).to eq([
                                                               { type: :chords, content: " G     Em    C" },
                                                               { type: :lyrics, content: "Some lyrics here" }
                                                             ])
      end
    end
  end
end
