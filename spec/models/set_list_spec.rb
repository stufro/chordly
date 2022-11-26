require "rails_helper"

describe SetList do
  subject { create(:set_list) }

  let(:chord_sheet1) { create(:chord_sheet) }
  let(:chord_sheet2) { create(:chord_sheet) }

  describe "#next_order" do
    it "returns 1 more than the greatest chord sheets order" do
      subject.chord_sheets_set_list.create(chord_sheet_id: chord_sheet1.id, order: 2)
      subject.chord_sheets_set_list.create(chord_sheet_id: chord_sheet2.id, order: 1)

      expect(subject.next_order).to eq 3
    end
  end
end
