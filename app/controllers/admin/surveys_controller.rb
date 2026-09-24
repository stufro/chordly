module Admin
  class SurveysController < BaseController
    def show
      @survey = Survey.find(params.expect(:key))
      @responses = SurveyResponse.where(survey_key: @survey.key)
      @answers = @responses.completed.pluck(:answers)
    end
  end
end
