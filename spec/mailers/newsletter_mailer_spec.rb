require "rails_helper"

describe NewsletterMailer do
  describe "#newsletter" do
    let(:mail) { described_class.with(subject: "Some subject", content: "Some content").newsletter }

    it "sends an email to all users where receive_emails? is true" do
      user1 = create(:user)
      create(:user, receive_emails: false)

      expect(mail.bcc).to contain_exactly(user1.email)
    end

    context "when the user param is present" do
      let(:user) { create(:user) }
      let(:mail) do
        described_class.with(subject: "Some subject", content: "Some content", user:).newsletter
      end

      it "sends an email to the given user" do
        create(:user, receive_emails: true)

        expect(mail.bcc).to contain_exactly(user.email)
      end
    end
  end
end
