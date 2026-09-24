require "rails_helper"

RSpec.describe SurveyResponse do
  describe "validating completed answers" do
    subject(:survey_response) { build(:survey_response, answers:, completed_at: Time.current) }

    let(:answers) { { "next_feature" => "sharing", "ad_free" => "maybe" } }

    it { is_expected.to be_valid }

    context "when a required question is unanswered" do
      let(:answers) { { "next_feature" => "sharing" } }

      it "is invalid with a message naming the question", :aggregate_failures do
        expect(survey_response).not_to be_valid
        expect(survey_response.errors[:answers]).to include(/ad-free/)
      end
    end

    context "when an answer is not one of the options" do
      let(:answers) { { "next_feature" => "teleportation", "ad_free" => "yes" } }

      it { is_expected.not_to be_valid }
    end

    context "when 'other' is chosen with text" do
      let(:answers) { { "next_feature" => "other", "next_feature_other" => "Metronome", "ad_free" => "no" } }

      it { is_expected.to be_valid }
    end

    context "when 'other' is chosen without text" do
      let(:answers) { { "next_feature" => "other", "ad_free" => "no" } }

      it { is_expected.not_to be_valid }
    end

    context "when 'other' is chosen for a question without an other option" do
      let(:answers) { { "next_feature" => "sharing", "ad_free" => "other", "ad_free_other" => "Depends" } }

      it { is_expected.not_to be_valid }
    end

    context "when the response is only dismissed" do
      subject(:survey_response) { build(:survey_response, answers: {}, dismissed_at: Time.current) }

      it { is_expected.to be_valid }
    end
  end
end
