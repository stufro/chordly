require "rails_helper"

describe "Trials" do
  describe "GET /trial/new" do
    it "returns ok" do
      get new_trial_path
      expect(response).to have_http_status(:ok)
    end

    it "sets a trial_user_id in the session" do
      get new_trial_path
      expect(session[:trial_user_id]).to be_present
    end

    it "destroys any existing trial chord sheets for this session" do
      get new_trial_path
      trial_user_id = session[:trial_user_id]
      create(:chord_sheet, trial: true, trial_user_id:)

      get new_trial_path
      expect(ChordSheet.where(trial_user_id:)).to be_empty
    end
  end
end
