require "rails_helper"

describe "Chord Sheets" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /chord_sheets" do
    it "returns ok" do
      get chord_sheets_path
      expect(response).to have_http_status(:ok)
    end

    it "assigns non-deleted chord sheets belonging to the user" do
      visible = create(:chord_sheet, user:)
      create(:chord_sheet, user:, deleted: true)
      other_user = create(:user)
      create(:chord_sheet, user: other_user)

      get chord_sheets_path
      expect(assigns(:chord_sheets)).to contain_exactly(visible)
    end
  end

  describe "GET /chord_sheets/new" do
    it "returns ok" do
      get new_chord_sheet_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /chord_sheets" do
    context "when the chord sheet is valid" do
      it "creates a chord sheet" do
        expect do
          post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }
        end.to change(ChordSheet, :count).by(1)
      end

      it "assigns the current user" do
        post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }
        expect(ChordSheet.last.user).to eq user
      end

      it "redirects to the chord sheet" do
        post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }
        expect(response).to redirect_to(ChordSheet.last)
      end

      it "starts the chord sheet with the user's styles" do
        user.update!(text_size: "small")
        create(:line_style, :heading, :blue, styleable: user)

        post chord_sheets_path, params: { chord_sheet: { name: "My Song", content: "G\nLyrics" } }

        expect([ChordSheet.last.text_size, ChordSheet.last.line_styles.map { [it.line_type, it.colour] }])
          .to eq ["small", [%w[heading blue]]]
      end
    end

    context "when the chord sheet is invalid" do
      it "sets a flash alert" do
        post "#{chord_sheets_path}.turbo_stream", params: { chord_sheet: { name: "" } }
        expect(flash[:alert]).to include("Failed to create chord sheet")
      end
    end
  end

  describe "GET /chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "returns ok" do
      get chord_sheet_path(chord_sheet)
      expect(response).to have_http_status(:ok)
    end

    it "wires the PDF export button to the download controller" do
      get chord_sheet_path(chord_sheet)
      export_button = response.parsed_body.at_css("#export")
      export_form = export_button.parent

      expect(
        target: export_button["data-pdf-download-target"],
        controller: export_form["data-controller"],
        action: export_form["data-action"],
        filename: export_form["data-pdf-download-filename-value"]
      ).to eq(
        target: "button",
        controller: "pdf-download",
        action: "submit->pdf-download#download",
        filename: "My amazing song.pdf"
      )
    end

    it "explains two columns might not be visible when enabled" do
      chord_sheet.update!(two_columns: true)
      get chord_sheet_path(chord_sheet)
      expect(response.body).to include("might not be visible on your screen size")
    end

    it "does not explain two columns when disabled" do
      get chord_sheet_path(chord_sheet)
      expect(response.body).not_to include("might not be visible on your screen size")
    end

    it "styles each line by its type" do
      create(:line_style, :chords, :red, styleable: chord_sheet)

      get chord_sheet_path(chord_sheet)
      content = response.parsed_body.at_css("#chord-sheet-content")

      expect(
        chords: content.at_css(".chord-line")["style"],
        lyrics: content.at_css(".lyric-line")["style"]
      ).to eq(chords: "font-weight: bold; color: #e03131", lyrics: "font-weight: normal")
    end

    it "sizes the chord sheet's text" do
      chord_sheet.update!(text_size: "small")

      get chord_sheet_path(chord_sheet)

      expect(response.parsed_body.at_css("#chord-sheet-content")["style"]).to eq "font-size: 12px"
    end

    it "sizes the chord sheet's text in the PDF" do
      chord_sheet.update!(text_size: "small")
      html = nil
      allow(Sghtmltopdf).to receive(:render) { |rendered| html = rendered }

      get chord_sheet_path(chord_sheet, format: :pdf)

      expect(Nokogiri::HTML(html).at_css("pre")["style"]).to eq "font-size: 12px"
    end

    it "styles each line by its type in the PDF" do
      create(:line_style, :chords, :red, styleable: chord_sheet)
      html = nil
      allow(Sghtmltopdf).to receive(:render) { |rendered| html = rendered }

      get chord_sheet_path(chord_sheet, format: :pdf)

      expect(Nokogiri::HTML(html).at_css(".chord-line")["style"]).to eq "font-weight: bold; color: #e03131"
    end

    context "when the user does not own the chord sheet" do
      let(:other_user) { create(:user) }
      let(:other_chord_sheet) { create(:chord_sheet, user: other_user) }

      it "redirects with an unauthorized alert" do
        get chord_sheet_path(other_chord_sheet)
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "PATCH /chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    context "when the update succeeds" do
      it "sets a flash notice" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { name: "Updated" } }
        expect(flash[:notice]).to eq "Changes saved"
      end

      it "saves the two-column preference" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { two_columns: true } }
        expect(chord_sheet.reload).to be_two_columns
      end

      it "saves line styles" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { line_styles_attributes: [
          { line_type: "chords", font_style: "italic", colour: "red" },
          { line_type: "lyrics", font_style: "bold", colour: "" }
        ] } }

        expect(chord_sheet.reload.line_styles.map { it.slice(:line_type, :font_style, :colour) }).to contain_exactly(
          { "line_type" => "chords", "font_style" => "italic", "colour" => "red" },
          { "line_type" => "lyrics", "font_style" => "bold", "colour" => nil }
        )
      end

      it "saves a heading size" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { line_styles_attributes: [
          { line_type: "heading", font_style: "bold", font_size: "largest" }
        ] } }

        expect(chord_sheet.reload.line_styles.map(&:font_size)).to eq ["largest"]
      end

      it "saves the text size" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { text_size: "larger" } }

        expect(chord_sheet.reload.text_size).to eq "larger"
      end

      it "applies the styles to the user's other chord sheets when asked" do
        other = create(:chord_sheet, user:)

        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream",
              params: { apply_to_all: "1", chord_sheet: { text_size: "larger" } }

        expect([other.reload.text_size, flash[:notice]]).to eq ["larger", "Styles applied to all your chord sheets"]
      end

      it "leaves the user's other chord sheets alone otherwise" do
        other = create(:chord_sheet, user:)

        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { text_size: "larger" } }

        expect(other.reload.text_size).to eq "normal"
      end

      it "updates an existing line style rather than adding another" do
        line_style = create(:line_style, :chords, :red, styleable: chord_sheet)

        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { line_styles_attributes: [
          { id: line_style.id, line_type: "chords", colour: "blue" }
        ] } }

        expect(chord_sheet.reload.line_styles.map(&:colour)).to eq ["blue"]
      end
    end

    context "when the update fails" do
      it "sets a flash alert" do
        patch "#{chord_sheet_path(chord_sheet)}.turbo_stream", params: { chord_sheet: { name: "" } }
        expect(flash[:alert]).to include("Failed to update chord sheet")
      end
    end

    context "when the user does not own the chord sheet" do
      let(:other_user) { create(:user) }
      let(:other_chord_sheet) { create(:chord_sheet, user: other_user) }

      it "redirects with an unauthorized alert" do
        patch "#{chord_sheet_path(other_chord_sheet)}.turbo_stream", params: { chord_sheet: { name: "Hack" } }
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "DELETE /chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "soft-deletes the chord sheet" do
      delete chord_sheet_path(chord_sheet)
      expect(chord_sheet.reload.deleted).to be true
    end

    it "redirects to chord sheets" do
      delete chord_sheet_path(chord_sheet)
      expect(response).to redirect_to(chord_sheets_path)
    end

    it "sets a flash notice" do
      delete chord_sheet_path(chord_sheet)
      expect(flash[:notice]).to eq "Chord sheet deleted"
    end
  end

  describe "PUT /chord_sheets/:id/transpose" do
    let(:chord_sheet) { create(:chord_sheet, user:) }

    it "returns ok" do
      put transpose_chord_sheet_path(chord_sheet), params: { direction: "up" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /chord_sheets/:id/compact" do
    let(:chord_sheet) { create(:chord_sheet, user:, content_string: "G\nVerse\n\n[Chorus]\nC\n\nChorus lyrics") }

    it "saves the chord sheet without blank lines, except before headings" do
      put compact_chord_sheet_path(chord_sheet)

      expect(chord_sheet.reload.content.pluck("content")).to eq ["G\r\n", "Verse\r\n", "\r\n", "[Chorus]\r\n", "C\r\n",
                                                                 "Chorus lyrics"]
    end
  end
end
