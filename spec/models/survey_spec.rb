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

  describe Survey::Question do
    let(:answers) do
      [
        { "next_feature" => "pdf", "next_feature_other" => "", "comments" => "Great app" },
        { "next_feature" => "pdf" },
        { "next_feature" => "other", "next_feature_other" => "Metronome" },
        { "comments" => "" }
      ]
    end
    let(:survey) { Survey.find("next_features") }

    describe "#tally" do
      it "counts each chosen option" do
        question = survey.questions.find { it.key == "next_feature" }
        expect(question.tally(answers)).to eq("pdf" => 2, "other" => 1)
      end
    end

    describe "#written_answers" do
      it "collects the 'other' text for a choice question" do
        question = survey.questions.find { it.key == "next_feature" }
        expect(question.written_answers(answers)).to eq ["Metronome"]
      end

      it "collects the answers to a text question" do
        question = survey.questions.find { it.key == "comments" }
        expect(question.written_answers(answers)).to eq ["Great app"]
      end
    end
  end
end
