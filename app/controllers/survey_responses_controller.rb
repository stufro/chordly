class SurveyResponsesController < ApplicationController
  def create
    @survey = Survey.find(params.expect(:survey_key))
    @survey_response = current_user.survey_responses.find_or_initialize_by(survey_key: @survey.key)

    if @survey_response.update(answers: answer_params, completed_at: Time.current)
      redirect_to survey_path(@survey.key), notice: "Thanks for taking part!"
    else
      render "surveys/show", status: :unprocessable_content
    end
  end

  private

  def answer_params
    params.fetch(:answers, {}).permit(*@survey.answer_keys).to_h.compact_blank
  end
end
