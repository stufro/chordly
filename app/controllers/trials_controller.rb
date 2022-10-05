class TrialsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @chord_sheet = ChordSheet.create!(
      name: "My Song", trial: true,
      content: ChordSheetModeller.new("G   Em   D\r\nType or paste your song here").parse
    )
    render "chord_sheets/show"
  end
end
