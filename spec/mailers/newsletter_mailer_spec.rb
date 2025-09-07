require "rails_helper"

describe NewsletterMailer do
  describe "#newsletter" do
    let(:user) { create(:user) }
    let(:mail) do
      described_class.with(
        subject: "Some subject",
        content: "Some content",
        email: user.email,
        user_uuid: user.uuid
      ).newsletter
    end

    it "sends an email to the given user" do
      create(:user, receive_emails: true)

      expect(mail.to).to contain_exactly(user.email)
    end

    it "includes the unsubscribe link" do
      create(:user, receive_emails: true)

      expect(mail.body).to include(unsubscribe_url(token: user.uuid))
    end
  end
end
