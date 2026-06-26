require "rails_helper"

describe "Newsletters" do
  let(:admin) { create(:user, user_type: :admin) }

  before { sign_in admin }

  describe "GET /newsletters/new" do
    it "returns ok" do
      get new_newsletter_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /newsletters" do
    let(:params) { { newsletter: { subject: "Hello", content: "Great news" } } }

    context "when sending a preview" do
      it "renders the new template" do
        post newsletters_path, params: params.merge(preview: "1")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when sending to all opted-in users" do
      it "enqueues an email for each subscribed user" do
        create(:user, receive_emails: true)
        expect do
          post newsletters_path, params: params
        end.to have_enqueued_mail(NewsletterMailer, :newsletter).at_least(:once)
      end

      it "does not enqueue an email for unsubscribed users" do
        unsubscribed = create(:user, receive_emails: false)
        post newsletters_path, params: params
        expect(enqueued_jobs.pluck(:args)).not_to include(
          include(hash_including("email" => unsubscribed.email))
        )
      end

      it "redirects to new newsletter" do
        post newsletters_path, params: params
        expect(response).to redirect_to(new_newsletter_path)
      end

      it "sets a notice" do
        post newsletters_path, params: params
        expect(flash[:notice]).to eq "Newsletter sent"
      end
    end
  end

  describe "authorization" do
    before { sign_in create(:user) }

    it "redirects non-admins" do
      get new_newsletter_path
      expect(response).to redirect_to("/")
    end
  end
end
