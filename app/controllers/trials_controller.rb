class TrialsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    session[:trial_user_id] = SecureRandom.base64
    @chord_sheet = ChordSheet.new(
      name: "My Song", trial: true, trial_user_id: session[:trial_user_id],
      content: "G   Em   D\r\nType or paste your song here"
    )
  end
end
