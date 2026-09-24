module SurveysHelper
  def bannered_survey
    return unless user_signed_in?

    closed_keys = current_user.survey_responses.closed.pluck(:survey_key)
    Survey.all.find { Flipper.enabled?(:"survey_#{it.key}", current_user) && closed_keys.exclude?(it.key) }
  end
end
