require "rails_helper"

describe NewslettersController do
  describe "POST create" do
    let(:email_subject) { "New Email Update" }
    let(:content) { "Hi, here's an email" }
    let(:user) { create(:user, admin: true) }

    before do
      allow(controller).to receive(:authenticate_user!).and_return true
      allow(controller).to receive(:current_user).and_return user
      allow(NewsletterMailer).to receive_message_chain(:with, :newsletter, :deliver_later)
    end

    it "calls the newsletter mailer" do
      post :create, params: { newsletter: { subject: email_subject, content: } }
      expect(NewsletterMailer).to have_received(:with).with(subject: email_subject, content:)
    end

    it "redirects to the new newsletter path" do
      post :create, params: { newsletter: { subject: email_subject, content: } }
      expect(response).to redirect_to new_newsletter_path
    end

    it "calls the mailer with the current user when the preview param is present" do
      post :create, params: { newsletter: { subject: email_subject, content: }, preview: "true" }
      expect(NewsletterMailer).to have_received(:with).with(subject: email_subject, content:, user:)
    end

    it "renders the new page when the preview param is present" do
      post :create, params: { newsletter: { subject: email_subject, content: }, preview: "true" }
      expect(response).to render_template(:new)
    end
  end
end
