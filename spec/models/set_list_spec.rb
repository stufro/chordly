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

  describe "#refresh_orders" do
    it "resets the orders when a chord sheet with a lower order is removed" do
      join_record1 = subject.chord_sheets_set_list.create(chord_sheet: chord_sheet1, order: 2)
      join_record2 = subject.chord_sheets_set_list.create(chord_sheet: chord_sheet2, order: 3)

      subject.refresh_orders
      expect([join_record1, join_record2].map(&:order)).to eq [1, 2]
    end
  end
end
