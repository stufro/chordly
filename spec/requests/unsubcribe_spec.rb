require "rails_helper"

describe "Unsubscribing" do
  let(:user) { create(:user, uuid: SecureRandom.uuid, receive_emails: true) }

  describe "/unsubscribe" do
    it "renders the show page" do
      get "/unsubscribe", params: { token: user.uuid }

      expect(response).to render_template(:show)
    end

    it "unsubscribes the user" do
      get "/unsubscribe", params: { token: user.uuid }

      expect(user.reload.receive_emails).to be false
    end
  end
end
