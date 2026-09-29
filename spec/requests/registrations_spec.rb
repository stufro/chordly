require "rails_helper"

describe "Registrations" do
  describe "POST /users" do
    let(:store) { ActiveSupport::Cache::MemoryStore.new }

    before do
      allow(RegistrationsController.cache_store).to receive(:increment) do |*args, **opts|
        store.increment(*args, **opts)
      end
    end

    def sign_up(index)
      reset!
      post "/users", params: {
        user: { email: "user#{index}@example.com", password: "password123", password_confirmation: "password123" }
      }
    end

    it "allows sign ups within the limit" do
      expect { 5.times { |index| sign_up(index) } }.to change(User, :count).by(5)
    end

    context "when the limit is exceeded" do
      before { 5.times { |index| sign_up(index) } }

      it "does not create the user" do
        expect { sign_up(5) }.not_to change(User, :count)
      end

      it "redirects back to sign up" do
        sign_up(5)
        expect(response).to redirect_to(new_user_registration_path)
      end

      it "explains why the sign up was refused" do
        sign_up(5)
        expect(flash[:alert]).to eq "Too many sign up attempts. Please try again later."
      end
    end
  end

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
