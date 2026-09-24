class SurveysController < ApplicationController
  def show
    @survey = Survey.find(params.expect(:key))
    @survey_response = current_user.survey_responses.find_or_initialize_by(survey_key: @survey.key)
  end

  def dismiss
    survey = Survey.find(params.expect(:key))
    current_user.survey_responses.find_or_create_by!(survey_key: survey.key).update!(dismissed_at: Time.current)

    redirect_back_or_to "/", status: :see_other
  end
end
