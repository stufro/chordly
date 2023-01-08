require "rails_helper"

describe SetListExporter do
  subject { described_class.new(set_list) }

  let(:set_list) { create(:set_list) }

  let(:test_fixture) { Rails.root.join("spec/fixtures/set_list_exporter/test.zip") }

  let(:controller) { instance_double ApplicationController, :controller, render_to_string: :some_html }
  let(:grover) { instance_double Grover, :grover, to_pdf: :some_pdf }
  let(:zip_io) { double.as_null_object }

  describe "#to_csv" do
    before do
      chord_sheet = create(:chord_sheet, name: "Foo")
      ChordSheetsSetList.create(position: 1, set_list:, chord_sheet:)

      allow(ApplicationController).to receive(:new).and_return controller
      allow(Grover).to receive(:new).and_return grover
      allow(Zip::OutputStream).to receive(:write_buffer).and_yield zip_io
      allow(zip_io).to receive(:put_next_entry)
      allow(zip_io).to receive(:write)
    end

    it "generates a zip file of all the chord sheet PDFs" do
      subject.to_zip
      expect(zip_io).to have_received(:put_next_entry).with("1 - Foo.pdf")
    end

    it "writes each pdf content" do
      subject.to_zip
      expect(zip_io).to have_received(:write).with(:some_pdf)
    end
  end
end
