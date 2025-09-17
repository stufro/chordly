require "rails_helper"

describe SetListExporter do
  subject { described_class.new(set_list, type) }

  let(:set_list) { create(:set_list) }
  let(:controller) { instance_double ApplicationController, :controller, render_to_string: :some_html }
  let(:wicked_pdf) { instance_double WickedPdf, :wicked_pdf, pdf_from_string: :some_pdf }
  let(:zip_io) { double.as_null_object }

  describe "#export" do
    before do
      allow(ApplicationController).to receive(:new).and_return controller
      allow(WickedPdf).to receive(:new).and_return wicked_pdf
    end

    context "when the type is 'single_file'" do
      let(:type) { "single_file" }

      it "renders the set list show.pdf.slim as a string of html" do
        subject.export
        expect(controller).to have_received(:render_to_string).with(
          template: "set_lists/show", formats: :pdf, layout: "application", assigns: { set_list: }
        )
      end

      it "turns the html into a pdf" do
        subject.export
        expect(wicked_pdf).to have_received(:pdf_from_string)
      end
    end

    context "when the type is not 'single_file'" do
      let(:type) { "something else" }

      before do
        chord_sheet = create(:chord_sheet, name: "Foo")
        ChordSheetsSetList.create(position: 1, set_list:, chord_sheet:)

        allow(Zip::OutputStream).to receive(:write_buffer).and_yield zip_io
        allow(zip_io).to receive(:put_next_entry)
        allow(zip_io).to receive(:write)
      end

      it "generates a zip file of all the chord sheet PDFs" do
        subject.export
        expect(zip_io).to have_received(:put_next_entry).with("1 - Foo.pdf")
      end

      it "writes each pdf content" do
        subject.export
        expect(zip_io).to have_received(:write).with(:some_pdf)
      end
    end
  end
end
