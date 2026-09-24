require "rails_helper"

RSpec.describe Survey do
  describe ".find" do
    it "builds the survey and its questions from config/surveys.yml" do
      survey = described_class.find("next_features")

      expect(survey.questions.map(&:key)).to eq %w[next_feature ad_free comments]
    end

    it "keeps option keys as strings" do
      question = described_class.find("next_features").questions.find { it.key == "ad_free" }

      expect(question.options.keys).to eq %w[yes maybe no]
    end

    it "raises not found for an unknown key" do
      expect { described_class.find("nope") }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
