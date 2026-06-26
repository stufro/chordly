require "rails_helper"

describe "Bin" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /bin" do
    it "returns ok" do
      get bin_index_path
      expect(response).to have_http_status(:ok)
    end

    it "assigns deleted chord sheets belonging to the user" do
      deleted = create(:chord_sheet, user:, deleted: true)
      create(:chord_sheet, user:, deleted: false)
      other_user = create(:user)
      create(:chord_sheet, user: other_user, deleted: true)

      get bin_index_path
      expect(assigns(:chord_sheets)).to contain_exactly(deleted)
    end

    it "assigns deleted set lists belonging to the user" do
      deleted = create(:set_list, user:, deleted: true)
      create(:set_list, user:, deleted: false)
      other_user = create(:user)
      create(:set_list, user: other_user, deleted: true)

      get bin_index_path
      expect(assigns(:set_lists)).to contain_exactly(deleted)
    end
  end

  describe "PATCH /bin/:resource_id" do
    context "when restoring a chord sheet" do
      let(:chord_sheet) { create(:chord_sheet, user:, deleted: true) }

      it "restores the chord sheet" do
        patch bin_path(chord_sheet, resource_type: "ChordSheet")
        expect(chord_sheet.reload.deleted).to be false
      end

      it "redirects to the bin" do
        patch bin_path(chord_sheet, resource_type: "ChordSheet")
        expect(response).to redirect_to(bin_index_path)
      end

      it "sets a flash notice" do
        patch bin_path(chord_sheet, resource_type: "ChordSheet")
        expect(flash[:notice]).to eq "Chord Sheet restored"
      end
    end

    context "when restoring a set list" do
      let(:set_list) { create(:set_list, user:, deleted: true) }

      it "restores the set list" do
        patch bin_path(set_list, resource_type: "SetList")
        expect(set_list.reload.deleted).to be false
      end

      it "sets a flash notice" do
        patch bin_path(set_list, resource_type: "SetList")
        expect(flash[:notice]).to eq "Set List restored"
      end
    end
  end
end
