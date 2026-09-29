require "rails_helper"

describe "Sessions" do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    it "responds unprocessable when the password is wrong so Turbo renders the errors" do
      post "/users/sign_in", params: { user: { email: user.email, password: "wrong-password" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /users/sign_out" do
    before { sign_in user }

    it "redirects with see other so Turbo follows it with a GET" do
      delete "/users/sign_out"
      expect(response).to have_http_status(:see_other)
    end
  end
end
