require "rails_helper"

describe "Chord sheet versions" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /chord_sheets/:chord_sheet_id/versions" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "returns ok" do
      get chord_sheet_versions_path(chord_sheet)
      expect(response).to have_http_status(:ok)
    end

    it "styles each version's lines by their type" do
      create(:line_style, :chords, :red, styleable: chord_sheet)
      chord_sheet.update!(name: "Renamed")

      get chord_sheet_versions_path(chord_sheet)

      chord_line = response.parsed_body.at_css(".version-container .chord-line")

      expect(chord_line["style"]).to eq "font-weight: bold; color: #e03131"
    end

    it "previews each version at the text size it was saved with" do
      chord_sheet.update!(text_size: "small")
      chord_sheet.update!(text_size: "larger")

      get chord_sheet_versions_path(chord_sheet)
      sizes = response.parsed_body.css(".version-container pre").pluck("style")

      expect(sizes).to eq ["font-size: 12px", "font-size: 14px"]
    end

    it "previews each version in the column layout it was saved with" do
      chord_sheet.update!(two_columns: true)
      chord_sheet.update!(two_columns: false)

      get chord_sheet_versions_path(chord_sheet)
      previews = response.parsed_body.css(".version-container pre").map { it.classes.include?("two-columns") }

      expect(previews).to eq [true, false]
    end
  end

  describe "PATCH /chord_sheets/:chord_sheet_id/versions/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "restores the chord sheet to that version" do
      chord_sheet.update!(name: "Renamed")

      patch chord_sheet_version_path(chord_sheet, chord_sheet.versions.last)

      expect(chord_sheet.reload.name).to eq "My amazing song"
    end

    it "redirects to the chord sheet" do
      chord_sheet.update!(name: "Renamed")

      patch chord_sheet_version_path(chord_sheet, chord_sheet.versions.last)

      expect(response).to redirect_to(chord_sheet)
    end

    context "when the user does not own the chord sheet" do
      let(:chord_sheet) { create(:chord_sheet, user: create(:user)) }

      it "leaves the chord sheet as it is" do
        chord_sheet.update!(name: "Renamed")

        patch chord_sheet_version_path(chord_sheet, chord_sheet.versions.last)

        expect(chord_sheet.reload.name).to eq "Renamed"
      end
    end
  end
end
