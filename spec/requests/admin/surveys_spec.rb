require "rails_helper"

describe "Admin surveys" do
  let(:user) { create(:user, user_type:) }
  let(:user_type) { :admin }

  before { sign_in user }

  describe "GET /admin/surveys/:key" do
    it "shows how many users chose each option" do
      create_list(:survey_response, 2, :completed)
      get "/admin/surveys/next_features"
      expect(response.body).to match(/Share chord sheets with bandmates.*?2/m)
    end

    it "shows written answers" do
      create(:survey_response, :completed,
             answers: { "next_feature" => "pdf", "ad_free" => "no", "comments" => "Needs a metronome" })
      get "/admin/surveys/next_features"
      expect(response.body).to include("Needs a metronome")
    end

    it "leaves out the admin's own answers" do
      create(:survey_response, :completed,
             user:, answers: { "next_feature" => "pdf", "ad_free" => "no", "comments" => "Testing" })
      get "/admin/surveys/next_features"
      expect(response.body).not_to include("Testing")
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get "/admin/surveys/next_features"
        expect(response).to redirect_to("/")
      end
    end
  end
end
