require "rails_helper"

describe "Support toast" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "PATCH /users/support_toast" do
    context "when action_type is 'dismiss'" do
      subject { patch "/users/support_toast", params: { action_type: "dismiss" } }

      it "returns 200" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "records support_toast_dismissed_at" do
        subject
        expect(user.reload.support_toast_dismissed_at).to be_within(2.seconds).of(Time.current)
      end

      it "does not set support_toast_clicked_at" do
        subject
        expect(user.reload.support_toast_clicked_at).to be_nil
      end
    end

    context "when action_type is 'click'" do
      subject { patch "/users/support_toast", params: { action_type: "click" } }

      it "returns 200" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "records support_toast_clicked_at" do
        subject
        expect(user.reload.support_toast_clicked_at).to be_within(2.seconds).of(Time.current)
      end

      it "does not set support_toast_dismissed_at" do
        subject
        expect(user.reload.support_toast_dismissed_at).to be_nil
      end
    end

    context "when action_type is unrecognised" do
      before { patch "/users/support_toast", params: { action_type: "unknown" } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.support_toast_dismissed_at).to be_nil }
      it { expect(user.reload.support_toast_clicked_at).to be_nil }
    end

    context "when not signed in" do
      it "returns unauthorized" do
        sign_out user
        patch "/users/support_toast", params: { action_type: "dismiss" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
