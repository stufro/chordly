require "rails_helper"

describe "Chord Sheets" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /chord_sheets" do
    it "returns ok" do
      get chord_sheets_path
      expect(response).to have_http_status(:ok)
    end

    it "assigns non-deleted chord sheets belonging to the user" do
      visible = create(:chord_sheet, user:)
      create(:chord_sheet, user:, deleted: true)
      other_user = create(:user)
      create(:chord_sheet, user: other_user)

      get chord_sheets_path
      expect(assigns(:chord_sheets)).to contain_exactly(visible)
    end
  end

  describe "GET /chord_sheets/new" do
    it "returns ok" do
      get new_chord_sheet_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /chord_sheets" do
    context "when the chord sheet is valid" do
      it "creates a chord sheet" do
        expect do
          post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }
        end.to change(ChordSheet, :count).by(1)
      end

      it "assigns the current user" do
        post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }
        expect(ChordSheet.last.user).to eq user
      end

      it "redirects to the chord sheet" do
        post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }
        expect(response).to redirect_to(ChordSheet.last)
      end
    end

    context "when the chord sheet is invalid" do
      it "sets a flash alert" do
        post "#{chord_sheets_path}.turbo_stream", params: { chord_sheet: { name: "" } }
        expect(flash[:alert]).to include("Failed to create chord sheet")
      end
    end
  end

  describe "GET /chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "returns ok" do
      get chord_sheet_path(chord_sheet)
      expect(response).to have_http_status(:ok)
    end

    context "when the user does not own the chord sheet" do
      let(:other_user) { create(:user) }
      let(:other_chord_sheet) { create(:chord_sheet, user: other_user) }

      it "redirects with an unauthorized alert" do
        get chord_sheet_path(other_chord_sheet)
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "PATCH /chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    context "when the update succeeds" do
      it "sets a flash notice" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { name: "Updated" } }
        expect(flash[:notice]).to eq "Changes saved"
      end
    end

    context "when the update fails" do
      it "sets a flash alert" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { name: "" } }
        expect(flash[:alert]).to include("Failed to update chord sheet")
      end
    end

    context "when the user does not own the chord sheet" do
      let(:other_user) { create(:user) }
      let(:other_chord_sheet) { create(:chord_sheet, user: other_user) }

      it "redirects with an unauthorized alert" do
        patch "#{chord_sheet_path(other_chord_sheet)}.turbo_stream", params: { chord_sheet: { name: "Hack" } }
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "DELETE /chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "soft-deletes the chord sheet" do
      delete chord_sheet_path(chord_sheet)
      expect(chord_sheet.reload.deleted).to be true
    end

    it "redirects to chord sheets" do
      delete chord_sheet_path(chord_sheet)
      expect(response).to redirect_to(chord_sheets_path)
    end

    it "sets a flash notice" do
      delete chord_sheet_path(chord_sheet)
      expect(flash[:notice]).to eq "Chord sheet deleted"
    end
  end

  describe "PUT /chord_sheets/:id/transpose" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "returns ok" do
      put transpose_chord_sheet_path(chord_sheet), params: { direction: "up" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /chord_sheets/:id/versions" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "returns ok" do
      get versions_chord_sheet_path(chord_sheet)
      expect(response).to have_http_status(:ok)
    end
  end
end
