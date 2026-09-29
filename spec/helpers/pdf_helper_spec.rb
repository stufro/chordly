require "rails_helper"

describe PdfHelper do
  describe "#wrappable_line" do
    it "keeps every space's width while allowing the line to wrap between them" do
      expect(helper.wrappable_line("G  Am\r\n")).to eq "G ​ ​Am"
    end

    it "drops trailing spaces so they can't wrap onto a line of their own" do
      expect(helper.wrappable_line("Am  \r\n")).to eq "Am"
    end

    it "keeps blank lines from collapsing" do
      expect(helper.wrappable_line("\r\n")).to eq " "
    end
  end
end
