require "rails_helper"

describe "Admin" do
  let(:user) { create(:user, admin:) }
  let(:admin) { true }

  before { sign_in user }

  describe "/admin" do
    it "renders the admin page" do
      get "/admin"
      expect(response).to render_template(:index)
    end

    context "when the user is not an admin" do
      let(:admin) { false }

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
end
