class SurveyResponse < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where.not(completed_at: nil) }
  scope :dismissed, -> { where.not(dismissed_at: nil) }
  scope :closed,    -> { completed.or(dismissed) }

  validate :answers_match_survey, if: :completed_at?

  def survey
    Survey.find(survey_key)
  end

  private

  def answers_match_survey
    survey.questions.reject { it.valid_answer?(answers) }.each do |question|
      errors.add(:answers, "need a valid answer to \"#{question.prompt}\"")
    end
  end
end
