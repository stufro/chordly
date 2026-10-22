require "rails_helper"

describe "Chord sheet styles" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "DELETE /chord_sheets/:chord_sheet_id/style" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    before do
      chord_sheet.update!(text_size: "larger")
      create(:line_style, :chords, :red, styleable: chord_sheet)
    end

    it "resets the chord sheet to the built-in styles" do
      delete "#{chord_sheet_style_path(chord_sheet)}.turbo_stream"

      expect([chord_sheet.reload.text_size, chord_sheet.line_styles]).to eq ["normal", []]
    end

    it "keeps the user's saved default styles" do
      user.apply_styles_to_chord_sheets(chord_sheet)

      delete "#{chord_sheet_style_path(chord_sheet)}.turbo_stream"

      expect(user.reload.text_size).to eq "larger"
    end

    it "re-renders the chord sheet" do
      delete "#{chord_sheet_style_path(chord_sheet)}.turbo_stream"

      expect(response).to have_http_status(:ok)
    end

    it "sets a flash notice" do
      delete "#{chord_sheet_style_path(chord_sheet)}.turbo_stream"

      expect(flash[:notice]).to eq "Styles reset"
    end

    context "when the user does not own the chord sheet" do
      let(:chord_sheet) { create(:chord_sheet, user: create(:user)) }

      it "leaves the chord sheet's styles as they are" do
        delete "#{chord_sheet_style_path(chord_sheet)}.turbo_stream"

        expect(chord_sheet.reload.text_size).to eq "larger"
      end
    end
  end
end
