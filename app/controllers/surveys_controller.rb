class SurveysController < ApplicationController
  def show
    @survey = Survey.find(params.expect(:key))
    @survey_response = current_user.survey_responses.find_or_initialize_by(survey_key: @survey.key)
  end
end
