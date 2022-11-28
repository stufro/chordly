require "rails_helper"

describe SetList do
  subject { create(:set_list) }

  let(:chord_sheet1) { create(:chord_sheet) }
  let(:chord_sheet2) { create(:chord_sheet) }

  describe "#next_position" do
    it "returns 1 more than the greatest chord sheets position" do
      subject.chord_sheets_set_list.create(chord_sheet_id: chord_sheet1.id, position: 2)
      subject.chord_sheets_set_list.create(chord_sheet_id: chord_sheet2.id, position: 1)

      expect(subject.next_position).to eq 3
    end
  end

  describe "#refresh_positions" do
    it "resets the orders when a chord sheet with a lower order is removed" do
      join_record1 = subject.chord_sheets_set_list.create(chord_sheet: chord_sheet1, position: 2)
      join_record2 = subject.chord_sheets_set_list.create(chord_sheet: chord_sheet2, position: 3)

      subject.refresh_positions
      expect([join_record1, join_record2].map(&:position)).to eq [1, 2]
    end
  end
end
