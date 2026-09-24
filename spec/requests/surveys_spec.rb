require "rails_helper"

describe "Surveys" do
  let(:user) { create(:user) }

  describe "GET /surveys/:key" do
    context "when signed in" do
      before { sign_in user }

      it "shows the survey questions" do
        get "/surveys/next_features"
        expect(response.body).to include("go ad-free")
      end

      it "returns not found for an unknown survey" do
        get "/surveys/nope"
        expect(response).to have_http_status(:not_found)
      end

      it "preselects previous answers" do
        create(:survey_response, :completed, user:)
        get "/surveys/next_features"
        expect(response.body).to match(/value="sharing"[^>]*checked|checked[^>]*value="sharing"/)
      end
    end

    context "when signed out" do
      it "returns to the survey after signing in", :aggregate_failures do
        get "/surveys/next_features"
        expect(response).to redirect_to(new_user_session_path)

        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to("/surveys/next_features")
      end
    end
  end

  describe "POST /surveys/:key/response" do
    subject(:submit) { post "/surveys/next_features/response", params: { answers: } }

    let(:answers) { { next_feature: "styling", ad_free: "maybe", comments: "Love it" } }

    before { sign_in user }

    it "records the completed response", :aggregate_failures do
      submit
      survey_response = user.survey_responses.sole
      expect(survey_response.answers).to eq("next_feature" => "styling", "ad_free" => "maybe", "comments" => "Love it")
      expect(survey_response.completed_at).to be_present
    end

    it "redirects back to the survey with thanks", :aggregate_failures do
      submit
      expect(response).to redirect_to("/surveys/next_features")
      expect(flash[:notice]).to match(/thank/i)
    end

    it "updates an existing response rather than adding another", :aggregate_failures do
      create(:survey_response, :completed, user:)
      expect { submit }.not_to change(SurveyResponse, :count)
      expect(user.survey_responses.sole.answers["next_feature"]).to eq "styling"
    end

    it "ignores answers for questions that aren't in the survey" do
      post "/surveys/next_features/response", params: { answers: answers.merge(admin: "yes") }
      expect(user.survey_responses.sole.answers).not_to have_key("admin")
    end

    context "when a required answer is missing" do
      let(:answers) { { next_feature: "styling" } }

      it "re-renders the survey without saving", :aggregate_failures do
        expect { submit }.not_to change(SurveyResponse, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
