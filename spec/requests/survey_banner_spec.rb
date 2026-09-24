require "rails_helper"

describe "Survey banner" do
  let(:user) { create(:user) }

  before { sign_in user }

  {
    "the homepage" => -> { "/" },
    "the library" => -> { "/chord_sheets" },
    "a chord sheet" => -> { "/chord_sheets/#{create(:chord_sheet, user:).id}" },
    "a set list" => -> { "/set_lists/#{create(:set_list, user:).id}" }
  }.each do |page, page_path|
    describe "visiting #{page}" do
      let(:path) { instance_exec(&page_path) }

      context "when the survey flag is enabled for the user" do
        before { Flipper.enable_actor(:survey_next_features, user) }

        it "links to the survey" do
          get path
          expect(response.body).to include('href="/surveys/next_features"')
        end

        it "hides the banner once the user has answered" do
          create(:survey_response, :completed, user:)
          get path
          expect(response.body).not_to include('href="/surveys/next_features"')
        end

        it "hides the banner once the user has dismissed it" do
          create(:survey_response, user:, dismissed_at: Time.current)
          get path
          expect(response.body).not_to include('href="/surveys/next_features"')
        end
      end

      context "when the user is also due the support toast" do
        let(:user) { create(:user, sign_in_count: 5, created_at: 40.days.ago) }

        it "shows the survey in place of the support toast", :aggregate_failures do
          Flipper.enable_actor(:survey_next_features, user)
          get path
          expect(response.body).to include('href="/surveys/next_features"')
          expect(response.body).not_to include("support-toast")
        end

        it "shows the support toast when there's no survey" do
          get path
          expect(response.body).to include("support-toast")
        end
      end

      context "when the survey flag is disabled" do
        it "does not link to the survey" do
          get path
          expect(response.body).not_to include('href="/surveys/next_features"')
        end
      end
    end
  end

  describe "PATCH /surveys/:key/dismiss" do
    subject(:dismiss) { patch "/surveys/next_features/dismiss", headers: { "HTTP_REFERER" => "/chord_sheets" } }

    it "records the dismissal" do
      dismiss
      expect(user.survey_responses.sole.dismissed_at).to be_within(2.seconds).of(Time.current)
    end

    it "redirects back to where the user was" do
      dismiss
      expect(response).to redirect_to("/chord_sheets")
    end

    it "keeps answers from an earlier completion" do
      create(:survey_response, :completed, user:)
      dismiss
      expect(user.survey_responses.sole.answers).to include("next_feature" => "sharing")
    end
  end
end
