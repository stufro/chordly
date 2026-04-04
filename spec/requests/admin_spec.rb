require "rails_helper"

describe "Admin" do
  let(:user) { create(:user, user_type:) }
  let(:user_type) { :admin }

  before { sign_in user }

  describe "/admin" do
    it "renders the admin page" do
      get "/admin"
      expect(response).to render_template(:index)
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get "/admin"
        expect(response).to redirect_to("/")
      end

      it "sets a flash message" do
        get "/admin"
        expect(flash[:alert]).to eq "You are not authorized to view this page"
      end
    end
  end

  describe "GET /admin/users/:id" do
    let(:target_user) { create(:user) }

    it "renders the user show page" do
      get admin_user_path(target_user)
      expect(response).to render_template(:show)
    end

    it "assigns the user" do
      get admin_user_path(target_user)
      expect(assigns(:user)).to eq target_user
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get admin_user_path(target_user)
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "GET /admin/chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet) }

    it "renders the chord sheet show page" do
      get admin_chord_sheet_path(chord_sheet)
      expect(response).to render_template(:show)
    end

    it "assigns the chord sheet" do
      get admin_chord_sheet_path(chord_sheet)
      expect(assigns(:chord_sheet)).to eq chord_sheet
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get admin_chord_sheet_path(chord_sheet)
        expect(response).to redirect_to("/")
      end
    end
  end
end
