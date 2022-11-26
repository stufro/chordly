require "rails_helper"

describe "Set lists" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "POST /set_lists" do
    context "when the set list creates successfully" do
      it "redirects to the set list" do
        post "/set_lists", params: { set_list: { name: "Foo" } }
        set_list = SetList.find_by(name: "Foo")

        expect(response).to redirect_to(set_list_path(set_list))
      end

      it "assigns the current user to the set list" do
        post "/set_lists", params: { set_list: { name: "Foo" } }
        set_list = SetList.find_by(name: "Foo")

        expect(set_list.user).to eq user
      end
    end

    context "when the set list fails to create" do
      it "renders the new page" do
        post "/set_lists", params: { set_list: { name: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH /set_list/:id" do
    context "when the set list updates successfully" do
      let(:set_list) { create(:set_list) }

      it "sets a flash message" do
        patch set_list_path(set_list, format: :turbo_stream), params: { id: set_list.id, set_list: { name: "Foo" } }

        expect(flash[:notice]).to eq "Changes saved"
      end
    end

    context "when the set list fails to update" do
      let(:set_list) { create(:set_list) }

      it "sets a flash message" do
        patch set_list_path(set_list, format: :turbo_stream), params: { id: set_list.id, set_list: { name: "" } }

        expect(flash[:alert]).to eq "Failed to update set list: Name can't be blank"
      end
    end
  end

  describe "PUT add_chord_sheet" do
    subject { put add_chord_sheet_set_list_path(set_list), params: { id: set_list.id, chord_sheet_id: chord_sheet.id } }

    let(:set_list) { create(:set_list) }
    let(:chord_sheet) { create(:chord_sheet) }

    it "adds the chord sheet to the set list" do
      subject
      expect(set_list.chord_sheets).to eq [chord_sheet]
    end

    it "redirects to the set list show" do
      subject
      expect(response).to redirect_to set_list
    end

    context "when it's the first chord sheet added to a set list" do
      it "sets the order to 1" do
        subject
        join_record = ChordSheetsSetList.find_by(chord_sheet_id: chord_sheet.id, set_list_id: set_list.id)
        expect(join_record.order).to eq 1
      end
    end

    context "when there is already a chord sheet on a set list" do
      it "sets the order to 1 more than the last chord sheet" do
        existing_sheet = create(:chord_sheet)
        ChordSheetsSetList.create(chord_sheet: existing_sheet, set_list:, order: 1)

        subject
        join_record = ChordSheetsSetList.find_by(chord_sheet_id: chord_sheet.id, set_list_id: set_list.id)
        expect(join_record.order).to eq 2
      end
    end
  end

  describe "PUT remove_chord_sheet" do
    subject do
      put remove_chord_sheet_set_list_path(set_list), params: { id: set_list.id, chord_sheet_id: chord_sheet1.id }
    end

    let(:set_list) { create(:set_list) }
    let(:chord_sheet1) { create(:chord_sheet, set_lists: [set_list]) }

    it "removes the chord sheet to the set list" do
      subject
      expect(set_list.chord_sheets).to eq []
    end

    it "redirects to the set list show" do
      subject
      expect(response).to redirect_to set_list
    end

    context "when there are existing chord sheets on a set list" do
      let(:set_list) { create(:set_list) }
      let(:chord_sheet1) { create(:chord_sheet) }
      let(:chord_sheet2) { create(:chord_sheet) }

      it "sets the order to 1 more than the last chord sheet" do
        ChordSheetsSetList.create(chord_sheet: chord_sheet1, set_list:, order: 1)
        chord_sheet2_join_record = ChordSheetsSetList.create(chord_sheet: chord_sheet2, set_list:, order: 2)

        subject
        expect(chord_sheet2_join_record.reload.order).to eq 1
      end
    end
  end
end
