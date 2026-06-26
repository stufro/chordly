require "rails_helper"

describe "Registrations" do
  describe "PATCH /users/theme" do
    let(:user) { create(:user) }

    before { sign_in user }

    context "with a valid theme" do
      it "updates the user's theme to light" do
        patch "/users/theme", params: { theme: "light" }
        expect(user.reload.theme).to eq "light"
      end

      it "updates the user's theme to dark" do
        patch "/users/theme", params: { theme: "dark" }
        expect(user.reload.theme).to eq "dark"
      end

      it "returns ok" do
        patch "/users/theme", params: { theme: "light" }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with an invalid theme" do
      it "does not update the theme" do
        original_theme = user.theme
        patch "/users/theme", params: { theme: "malicious" }
        expect(user.reload.theme).to eq original_theme
      end
    end
  end

  describe "PATCH /users/support_toast" do
    context "when signed in" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "returns ok" do
        patch "/users/support_toast", params: { action_type: "dismissed" }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when not signed in" do
      it "returns unauthorized" do
        patch "/users/support_toast", params: { action_type: "dismissed" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
